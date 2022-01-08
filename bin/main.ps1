# Backupskript
# 08.01.2022
# Luis Gjokaj
# main.ps1
# Version 1.5 (nach 5 mal bearbeiten der Finalversion)

$backupPfad = "..\TopBck\" # Standartpfad fuer das Backup
$sourcePfad = "..\TopSrc\*" # StandartPfad fuer die Source
$logName = Get-Date -Format 'dd-MM-yyyy HH-mm-ss' # Name der Log-Datei (Jetzige Zeit und heutiges Datum)
$logPfad =  "..\log\" + $logName + ".log" #Pfad der LogDatei

Write-Host "Rufen Sie makeBackup um das Backup zu starten."

# Erstellt ein vollstaendiges Backup einer Directory. Keine Parameter.
function makeBackup {
    $answer = Read-Host "Wollen Sie die Pfade fuer Backup, source, und log aendern?(n/y) "

    # Verschiedne Pfaede werden ueberschrieben falls man das will. Die auswahl wird mit if else geprueft.
    if ($answer -eq "y") {
        $logpfad = Read-Host "Geben sie den gewuenschten Pfad fuer das Logfile an: "
        $backupPfad = Read-Host "Geben sie den gewuenschten Pfad fuer das Backup an: "
        $sourcePfad = Read-Host "Geben sie den gewuenschten Pfad fuer die Source an: "
    } elseif ($answer -ne "n") {
        Write-Host "Falsche Eingabe. Programm wird geschlossen."
        exit
    }

    # Falls nur ein Pfad geandert worden ist, werden die anderen wieder zurueck gestellt auf den Standartpfad.
    if ($backupPfad -eq "") {
        $backupPfad = "..\TopBck\"
    }
    if ($logPfad -eq "") {
        $logPfad =  "..\log\" + $logName + ".log"
    }
    if ($sourcePfad -eq "") {
        $sourcePfad = "..\TopSrc\*"
    }

    # Alle files im Backupverzeichnis werden geloescht und das Backup wird durchgefuehrt
    try {
        Remove-Item -Recurse -Force -Exclude "TopBck" $backupPfad -ErrorAction stop
        copy-item -Path $sourcePfad -Destination $backupPfad -Recurse -ErrorAction stop
    }
    catch {
        write-Host "Es ist ein Fehler Aufgetreten. Fuehren Sie das Skript bitte wieder aus."
    }

    # Log Datei wird erstellt und ausgegeben.
    get-childitem -path $sourcePfad -Recurse | Select-Object name | out-file -FilePath $logpfad

    # SourcePfad wird umgeaendert fuer pruefungszwecke.
    if($sourcePfad -eq "..\TopSrc\*") {
        $sourcePfad = "..\TopSrc\"
    }

    # Daten ueber die Verzeichnisse werden hier gespeichert.
    $backupFiles = (get-childitem -path $backupPfad -Recurse)
    $sourceFiles = (get-childitem -path $sourcePfad -Recurse)

    # Geprueft ob die Dokumentanzahl gleich ist. Falls ja, ist das Backup erfolgreich durchgefuehrt worden.
    if ($backupFiles.count -eq $sourceFiles.count) {
        write-host "Das Backup wurde erfolgreich durchgefuehrt"
    }
    else {
        write-host "Nicht alle Files konnten kopiert werden. Fuehren Sie das Skript bitte noch mals aus."
    }
}
