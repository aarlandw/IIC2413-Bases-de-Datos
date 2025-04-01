<?php

include 'csv_handling.php';
include 'validation_maps.php';


function filterValidationMap(array $columnMap, array $fullValidationMap): array
{
    $filtered = [];

    foreach ($columnMap as $enum) {
        $key = $enum->name; // Use the string name of the enum as the key
        if (isset($fullValidationMap[$key])) {
            $filtered[$key] = $fullValidationMap[$key];
        }
    }

    return $filtered;
}


function validateRow(array $row, array $validationMap): bool
{
    foreach ($validationMap as $key => $rule) {
        $value = $row[$key] ?? null;

        // Check if the field is nullable and the value is null or empty
        if ($rule['nullable'] && (is_null($value) || $value === '')) {
            continue; // Skip validation for nullable fields
        }

        // Skip validation if no validator function is defined
        if (empty($rule['validatorFunction'])) {
            continue; // No validation needed for this field
        }

        // Call the validator function dynamically
        $validator = $rule['validatorFunction'];
        if (!function_exists($validator) || !$validator($value)) {
            return false; // Validation failed
        }
    }
    return true; // All fields are valid
}


function extractPartialRow(array $row, array $validationMap): array
{
    $partialRow = [];

    foreach ($validationMap as $key => $rule) {
        if (isset($row[$key])) {
            $partialRow[$key] = $row[$key];
        }
    }

    return $partialRow;
}

function filterData(array $data, array $validationMap): array
{
    $filteredData = [];
    foreach ($data as $row) {
        if (validateRow($row, $validationMap)) {
            $filteredData[] = extractPartialRow($row, $validationMap);
        }
    }
    return $filteredData;
}

function filterAndWriteData(array $unfilteredData, array $validationMap, string $outputFilePath): void
{
    $filteredData = filterData($unfilteredData, $validationMap);
    writeCSV($filteredData, $outputFilePath, array_keys($validationMap));
}


function separateAndWriteInvalidData(array $data, array $validationMap, string $invalidOutputFilePath): array
{
    $cleanData = [];
    $invalidData = [];

    foreach ($data as $row) {
        if (validateRow($row, $validationMap)) {
            $cleanData[] = $row; 
        } else {
            $invalidData[] = $row; 
        }
    }

    
    if (!empty($invalidData)) {
        writeCSV($invalidData, $invalidOutputFilePath, array_keys($validationMap));
    }

    return $cleanData; 
}
