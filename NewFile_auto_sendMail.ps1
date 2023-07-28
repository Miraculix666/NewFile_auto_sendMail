
# Öffne den Windows Task Scheduler:

# Drücke die Tastenkombination "Windows + R", um das "Ausführen"-Fenster zu öffnen.
# Gib "taskschd.msc" ein und klicke auf "OK".
# Im Task Scheduler klicke auf "Aktionen" und dann auf "Aktion erstellen...".
# Wähle "Programm starten" und gebe als Programm den Pfad zur PowerShell ausführbaren Datei "powershell.exe" ein. Normalerweise befindet sich diese Datei in "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe".
# Als "Argumente" gib Folgendes ein, um das Skript auszuführen:

# -ExecutionPolicy Bypass -File "C:\Pfad\Zum\Skript\SendNewFileEmail.ps1"

# Ersetze "C:\Pfad\Zum\Skript" durch den tatsächlichen Pfad zu deinem Skript.
# Klicke auf "Weiter" und gib im nächsten Schritt einen Namen für die Aufgabe ein (z. B. "CheckForNewFileTask").
# Wähle die Option "Täglich" und stelle sicher, dass "Alle 1 Stunde" ausgewählt ist.
# Wähle einen Startzeitpunkt für die Aufgabe und lege die entsprechende Startzeit fest.
# Bestätige die Einstellungen und klicke auf "Fertig stellen", um die Aufgabe zu erstellen.



# Konfiguration - Passe die folgenden Variablen an deine Bedürfnisse an
$FromEmail = "deine_email@beispiel.com"
$ToEmail = "ziel_email@beispiel.com"
$Subject = "Neue Datei"
$Body = "Hier ist die neue Datei, die du angefordert hast."

# Pfad des Zielordners, in dem nach neuen Dateien gesucht werden soll
$FolderPath = "C:\Pfad\Zum\Zielordner"

# Pfad zur Protokolldatei
$LogFilePath = "C:\Pfad\Zum\Protokoll\log.txt"

# Definiere eine Funktion, um eine E-Mail zu versenden
function Send-Email {
    param (
        [string]$From,
        [string]$To,
        [string]$Subject,
        [string]$Body,
        [string]$AttachmentPath
    )

    $Outlook = New-Object -ComObject Outlook.Application
    $Mail = $Outlook.CreateItem(0)
    $Mail.To = $To
    $Mail.Subject = $Subject
    $Mail.Body = $Body

    if ($AttachmentPath) {
        $Mail.Attachments.Add($AttachmentPath)
    }

    $Mail.Send()
}

# Überprüfe, ob im Zielordner neue Dateien vorhanden sind
$NewestFile = Get-ChildItem -Path $FolderPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($NewestFile) {
    # Prüfe, ob die Datei bereits im Protokoll verzeichnet ist
    $LogFileContent = Get-Content -Path $LogFilePath -ErrorAction SilentlyContinue
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
    Write-Host "Keine neue Datei im Zielordner gefunden."
}
