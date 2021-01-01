# How To Run Unit Test

First you need to install Mockingbird framework in your project, go to the Mockingbird Folder.
```sh
$ cd /Pods/MockingbirdFramework 
```

Then install the framework
```sh
make install-prebuilt
```

After the process complete, you need to go back to the project root directory and install the framework.
```sh
mockingbird install --target KitaNontonTests --sources 'KitaNonton'
```

Then the last thing you need to do is generate a mock.
```sh
mockingbird generate --targets 'KitaNonton' --output 'MockingbirdMocks/KitaNontonTests-KitaNontonMocks.generated.swift' --disable-cache --verbose
```
