<?php


function readCSV($filePath)
{
    // Check if file exists
    if (!file_exists($filePath) || !is_readable($filePath)) {
        echo "File not found or is not readable: $filePath\n";
        return false;
    }

    $data = [];
    $header = null;
    // Open the CSV file for reading
    if (($handle = fopen($filePath, 'r')) !== false) {
        // Read CSV data row by row
        while (($row = fgetcsv($handle, 1000, ',')) !== false) {
            if (!$header) {
                // Store the first row as header
                $header = $row;
                continue;
            }
            $data[] = array_combine($header, $row);
        }
        fclose($handle);
    }

    return $data;
}

function writeCSV(array $data, string $filePath, array $header): void
{
    assert($filePath !== '', 'File path cannot be empty');
    assert($header !== [], 'Header cannot be empty');

    // Check if data is empty
    if (empty($data)) {
        echo "No data to write to the file: $filePath\n";
        return;
    }
   
    // Open the file for writing (or create it if it doesn't exist)
    if (($handle = fopen($filePath, 'w')) !== false) {
        // Write the header row
        fputcsv($handle, $header);

        // Write each row of data into the file
        foreach ($data as $row) {
            fputcsv($handle, $row);
        }
        fclose($handle);
    } else {
        echo "Error opening the file for writing: $filePath\n";
    }
}



