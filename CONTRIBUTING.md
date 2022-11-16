# Come riprodurre i risultati

Perchè tutto il team possa collaborare al progetto, è importante che tutti sappiano come abbiamo fatto a ottenere un certo risultato.

## Come compilare

Per compilare il codice a noi assegnato, è necessario:

1. Accedere alla cartella in cui è contenuto:
   ```console
   $ cd ./OpenMP/linear-algebra/kernels/atax
   ```

2. Eseguire il Makefile:
   ```console
   $ make clean all
   ```

## Come debuggare e profilare

Ho configurato il [Makefile](OpenMP/linear-algebra/kernels/atax/Makefile) con un phony target che esegue il programma 9 volte e calcola il tempo di esecuzione medio:

1. Accedere alla cartella in cui è contenuto:
   ```console
   $ cd ./OpenMP/linear-algebra/kernels/atax
   ```

2. Eseguire il Makefile:
   ```console
   $ make bench
   ```

> Nota: funziona solo su sistemi UNIX-like!
