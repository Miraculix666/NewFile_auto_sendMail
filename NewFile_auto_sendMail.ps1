# Konfiguration - Passe die folgenden Variablen an deine Bedürfnisse an
$FromEmail = "deine_email@beispiel.com"
$ToEmail = "ziel_email@beispiel.com"
$Subject = "Neue Datei"
$Body = "Hier ist die neue Datei, die du angefordert hast."

# Pfad des Zielordners, in dem nach neuen Dateien gesucht werden soll
$FolderPath = "C:\Pfad\Zum\Zielordner"

# Pfad zur Protokolldatei
$LogFilePath = "C:\Pfad\Zum\Protokoll\log.txt"

# Funktion zum Versenden einer E-Mail mit .NET Framework-Komponenten
function Send-Email {
    param (
        [string]$From,
        [string]$To,
        [string]$Subject,
        [string]$Body,
        [string]$AttachmentPath
    )

    # Code zum Senden der E-Mail (wie in der vorherigen Version)
    # ...

}

# Endlosschleife, um das Skript zu wiederholen, bis alle Dateien gesendet wurden
while ($true) {
    # Überprüfe, ob im Zielordner neue Dateien vorhanden sind
    $NewestFile = Get-ChildItem -Path $FolderPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($NewestFile) {
        # Prüfe, ob die Datei bereits im Protokoll verzeichnet ist
        if (-Not (Test-Path $LogFilePath)) {
            New-Item -Path $LogFilePath -ItemType File | Out-Null
        }

        $LogFileContent = Get-Content -Path $LogFilePath
        $FileAlreadySent = $LogFileContent -match $NewestFile.Name

        if (-Not $FileAlreadySent) {
            # Sende die E-Mail mit der neuen Datei als Anhang
            Send-Email -From $FromEmail -To $ToEmail -Subject $Subject -Body $Body -AttachmentPath $NewestFile.FullName

            # Schreibe den Dateinamen in die Protokolldatei
            Add-Content -Path $LogFilePath -Value $NewestFile.Name
        } else {
            Write-Host "Die Datei wurde bereits gesendet: $($NewestFile.Name)"
        }
    } else {
        Write-Host "Keine neue Datei im Zielordner gefunden. Das Skript wird beendet."
        break  # Beende die Endlosschleife, wenn keine neuen Dateien mehr vorhanden sind
    }

    # Warte für eine Stunde, bevor das Skript erneut überprüft wird
    Start-Sleep -Seconds 3600
}
