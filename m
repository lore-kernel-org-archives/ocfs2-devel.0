From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar 23 20:41:20 2004
Subject: [Ocfs2-devel] [BUG]mmap changes not not persisted
Message-ID: <200403240241.i2O2fCqV013880@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While try to figure out the correct way to make a 2.6 build flush out
it's buffers to disk so that all changes are not lost when the file closes,
I discovered a problem with mmap on a 2.4 build.

I created a new bugzilla bug, that explains the problem at
http://oss.oracle.com/bugzilla/show_bug.cgi?id=50

Here is a cut-n-past from my description in the bug report:

When mmap is used over write data in an existing file, the changes made are
lost once the file is closed.

This can be reproduced in a test case that will:
(SETUP) create a file of 100bytes and null out the contents of the file.
1. open the target file
2. mmap a region of the file
3. memset the pointer returned from mmap to some non-null char
4. unmap and close the file
5. hexdump the file and notice none of the changes were persisted to disk

If you were to either create a new file, or extend the existing file 
and then mmap the new region of the file, then the changes will successfully
make their way to the disk.

I am seeing this bug on version 798 of the svn repository, on a 2.4.22 based
Fedora distribution.


------- Additional Comment #1 From Rusty Lynch 2004-03-23 20:34 -------

Created an attachment (id=3)
Not so simple test case for reading and writing to a file

The following attachment is a little unit test that I am using to track down
problems with reading/writing to a file.

Using the test case, you can expose this bug by:

dd bs=1K count=1 if=/dev/urandom of=testme.bin
read_write --filename=testme.bin --size=20 --offset=0 --close --mmap

This will attempt to 
* mmap the first 20 bytes of the testme.bin file
* write a known value of random numbers
* close and reopen the file
* remap the first 20 bytes of the file
* and then read the first 20 bytes and compare it to the known value
