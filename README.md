renlist
=================================

renlist, Rename by List. Rename files in the directory based on the list.

Written by [Bayu Aditya H](http://ba.yuah.web.id/).

Run Perl
--------

```sh
perl renlist.pl files-list [comma delimiter]
```

example:

```sh
perl renlist.pl files-list.txt
```

or

```sh
perl renlist.pl files-list.txt ";"
```

Files List Structures
---------------------

```text
   Old file name.ext{\dem.}New file name.ext{\dem.}[New mod. time{\dem.}[New access time]]
```

* **Old file name.ext**, old file nameyou want to change;
* **New file name.ext**, target file name;
* **New modification time**, *(optional)* new modification timestamps. Use format `Y-M-D H:m:s`;
* **New access time**, *(optional)* new modification timestamps. Use format `Y-M-D H:m:s`.

Change logs
-----------
* **0.1.1** — (2014/05/18) Added changing the timestamps support.
* **0.1.0** — (2014/05/08) Initial release.

Questions?
-----
If there are any questions, please feel free to contact [Bayu Aditya H](https://github.com/bayuah).