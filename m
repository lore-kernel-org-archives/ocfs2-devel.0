From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Aug 11 16:03:54 2004
Subject: [Ocfs2-devel] posix / performance
Message-ID: <3ACA40606221794F80A5670F0AF15F8405251CDB@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


>-----Original Message-----
>From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
>Sent: 2004=C4=EA8=D4=C211=C8=D5 13:26
>To: Ling, Xiaofeng
>Cc: ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] posix / performance
>
>First off, thanks!
>
>On Thu, Aug 12, 2004 at 03:48:07AM +0800, Ling, Xiaofeng wrote:
>> syscall test in ltp(not include link )
>Why not the link tests? We support that fully now...
see the result for link below

>> below is all the failed info. attach is full output
>> =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>  TDIRECTORY=3D/ocfs ./runalltests.sh -q -f `pwd`/runtest/syscall-file
>> access02    1  BROK  :  open(test_file1, O_RDWR|O_CREAT,=20
>0644) Failed, errno=3D13 :Permission denied
>What's up with all the permission denied errors? Is this=20
>OCFS2? We allow
>changing permissions on all files / directores, including root...
>Did we fail to change them properly (a bug?) or did the test=20
>suite never even try to set the permissions?
I'll investigate these breaks and fails.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
INFO: Test start time: Sat Aug  7 23:46:31 CST 2004
link01      1  PASS  :  link(2) to a symbolic link, which is pointing to =
an existing object file worked - file created and link count adjusted
link01      2  PASS  :  link(2) to a symbolic link, which is pointing to =
a non-existing object file worked ok - file created and link count =
adjusted.
link02      1  PASS  :  link(tfile, lfile) returned 0 and link cnts =
match
link03      1  PASS  :  link(lkfile_7644, lkfile_7644.[1-10]) ret 0 for =
10 files, stat linkcounts match 10
link04      1  PASS  :  link(<non-existent file>, <nefile>) Failed, =
errno=3D2
link04      2  PASS  :  link(<path is empty string>, <nefile>) Failed, =
errno=3D2
link04      3  PASS  :  link(<path contains a non-existent file>, =
<nefile>) Failed, errno=3D2
link04      4  PASS  :  link(<path contains a regular file>, <nefile>) =
Failed, errno=3D20
link04      5  PASS  :  link(<pathname too long>, <nefile>) Failed, =
errno=3D36
link04      6  PASS  :  link(<address beyond address space>, <nefile>) =
Failed, errno=3D14
link04      7  PASS  :  link(<negative address>, <nefile>) Failed, =
errno=3D14
link04      8  PASS  :  link(<regfile>, <empty string>) Failed, =
errno=3D2
link04      9  PASS  :  link(<regfile>, <path contains a non-existent =
file>) Failed, errno=3D2
link04     10  FAIL  :  link(<regfile>, <path contains a regular file>) =
Failed, errno=3D20, expected errno:2
link04     11  PASS  :  link(<regfile>, <pathname too long>) Failed, =
errno=3D36
link04     12  PASS  :  link(<regfile>, <address beyond address space>) =
Failed, errno=3D14
link04     13  PASS  :  link(<regfile>, <negative address>) Failed, =
errno=3D14
link04     14  PASS  :  link(<regfile>, <regfile2>) Failed, errno=3D17
link05      1  PASS  :  link(lkfile_7646, lkfile_7646.[1-1000]) ret 0 =
for 1000 files, stat linkcounts match 1000
link06      1  PASS  :  link() fails with expected error EACCES errno:13
link07      1  BROK  :  mkdir(2) of testdir_1 failed=20
