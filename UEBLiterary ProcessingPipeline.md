## UEB Literary Braille Transcription

#### Process .txt to /xml files

#### Increment Page Numbers

To add 1 to page numbers at the end of page to generate page change indicators for braille transcriptions

 "~~~" is a character that does not appear in the file and was put there solely to mark page numbers to greatly reduce the stress on my limited sed skills

```zsh
sed -i -r 's/(~)([0-9]*)/echo "\1$((\2+1))"/ge' [file path]
```

#### Copy and Paste the following as the first line(s) of the file

```xml-dtd
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<book>
```

#### Use the following tags to format the document as needed:

```xml-dtd
<h1> ... </h1>
<h2> ... </h2>
<h3> ... </h3> 
<list>
	<li> ... </li>
	<li> ... </li> 
</list>
<p> ... </p>
<blockquote> ... <blockquote>
```

#### End file by by closing the \<book> tag on the last line

```
</book>
```

### LiblouisUTDML transcription into UEB

```zsh
# For .xml files
for i in [file path]/*.xml; do
file2brl -f [path to preferences.cfg] ${i} [path to output]"Rough".brf
done
```


