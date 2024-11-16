# Required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Image Stitcher"
$form.Size = New-Object System.Drawing.Size(400, 400)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true  # Set the form to be always on top

# Controls
$label1 = New-Object System.Windows.Forms.Label
$label1.Text = "Drag-n-drop images (multiple images allowed):"
$label1.Location = New-Object System.Drawing.Point(10, 20)
$label1.AutoSize = $true

$textBoxImages = New-Object System.Windows.Forms.TextBox
$textBoxImages.Location = New-Object System.Drawing.Point(10, 50)
$textBoxImages.Width = 360
$textBoxImages.Height = 100
$textBoxImages.Multiline = $true   # Allow multiple lines for dropped paths
$textBoxImages.AllowDrop = $true   # Enable drag and drop

# Checkboxes for stitching options
$checkBoxHorizontal = New-Object System.Windows.Forms.CheckBox
$checkBoxHorizontal.Text = "Stitch Horizontally"
$checkBoxHorizontal.Location = New-Object System.Drawing.Point(10, 160)
$checkBoxHorizontal.Checked = $true  # Default to horizontal stitching

$checkBoxVertical = New-Object System.Windows.Forms.CheckBox
$checkBoxVertical.Text = "Stitch Vertically"
$checkBoxVertical.Location = New-Object System.Drawing.Point(150, 160)

# Button to stitch images
$buttonStitch = New-Object System.Windows.Forms.Button
$buttonStitch.Text = "Stitch Images"
$buttonStitch.Location = New-Object System.Drawing.Point(10, 200)

# Results label
$resultLabel = New-Object System.Windows.Forms.Label
$resultLabel.Location = New-Object System.Drawing.Point(10, 240)
$resultLabel.AutoSize = $true

# Help button
$buttonHelp = New-Object System.Windows.Forms.Button
$buttonHelp.Text = "Help"
$buttonHelp.Location = New-Object System.Drawing.Point(280, 200)

# Drag-and-drop event handler for the text box
$textBoxImages.Add_DragEnter({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [System.Windows.Forms.DragDropEffects]::Copy
    } else {
        $_.Effect = [System.Windows.Forms.DragDropEffects]::None
    }
})

$textBoxImages.Add_DragDrop({
    $files = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    if ($files.Count -gt 0) {
        # Join file paths into a single string with line breaks for display
        $textBoxImages.Text += [string]::Join("`n", $files) + "`n"  
    }
})

# Button click event for stitching images
$buttonStitch.Add_Click({
    try {
        # Get image paths from text box and split into an array
        $imagePaths = $textBoxImages.Text.Replace('"', '').Trim().Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)

        # Check if at least one image is provided
        if ($imagePaths.Length -lt 1) {
            $resultLabel.Text = "Please drop at least one image."
            return
        }

        # Check if all images (paths) exist and trim whitespace
        foreach ($imagePath in $imagePaths) {
            if (-not (Test-Path $imagePath.Trim())) {
                $resultLabel.Text = "One or more image paths are invalid."
                return
            }
        }

        # Extract just the image names (without path and extension) from the first image for output naming
        $firstImageName = [System.IO.Path]::GetFileNameWithoutExtension($imagePaths[0].Trim())

        # Get the directory of the first image to save output there
        $outputDirectory = [System.IO.Path]::GetDirectoryName($imagePaths[0].Trim())

        # Create the output filename using the name of the first image with "_combined" suffix and .jpg extension
        $outputPath = Join-Path -Path $outputDirectory -ChildPath "$($firstImageName)_combined.jpg"

        # Check stitch direction based on user-definer checkbox selection and stitch accordingly
        if ($checkBoxHorizontal.Checked) {
            & magick convert @($imagePaths) +append "$outputPath"  # Stitch horizontally (side by side)
        } elseif ($checkBoxVertical.Checked) {
            & magick convert @($imagePaths) -append "$outputPath"  # Stitch vertically (on top of each other)
        }

        # Display result with full output path saved
        $resultLabel.Text = "Images have been stitched together and saved as: `n$outputPath"

        # Prompt user to continue or exit
        $dialogResult = [System.Windows.Forms.MessageBox]::Show("Do you want to stitch another set of images?", "Continue?", [System.Windows.Forms.MessageBoxButtons]::YesNo)

        if ($dialogResult -eq [System.Windows.Forms.DialogResult]::No) {
            $form.Close()  # Close the form if user chooses 'No'
        } else {
            # Clear text box for new input if user chooses 'Yes'
            $textBoxImages.Clear()
            $resultLabel.Text = ""
            $checkBoxHorizontal.Checked = $true     # Reset to default option (horizontal)
            $checkBoxVertical.Checked = $false      # Reset vertical checkbox state 
        }

    } catch {
        $resultLabel.Text = "An error occurred: $_"
    }
})

# Button click event for help button
$buttonHelp.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("This is a compact tool that combines multiple photos into one. For example, you can combine several pictures into a single panoramic view.`n`nHow it works:`n1. Select multiple pictures and drop them into the window.`n`nUpdating/changing tool:`n1. If it is not clear how the code works, insert code into ChatGPT or another LLM so it can explain it to you.`n2. If you want to add new functionality but you don't understand PowerShell, you can also use ChatGPT or similar LLM to figure it out.", "Help", [System.Windows.Forms.MessageBoxButtons]::OK)
})

# Controls to the form
$form.Controls.Add($label1)
$form.Controls.Add($textBoxImages)
$form.Controls.Add($checkBoxHorizontal)
$form.Controls.Add($checkBoxVertical)
$form.Controls.Add($buttonStitch)
$form.Controls.Add($resultLabel)
$form.Controls.Add($buttonHelp)

# Show the form
$form.ShowDialog()
