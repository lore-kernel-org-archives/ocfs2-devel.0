From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Aug  5 21:17:54 2004
Subject: [Ocfs2-devel] Error message shows when create and rmdir
Message-ID: <3ACA40606221794F80A5670F0AF15F8405167434@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

=20

>-----Original Message-----
>From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
>Sent: 2004=C4=EA8=D4=C25=C8=D5 18:27
>> (18503) commit_thread: flushed 1 transactions, releasing 3 locks
>> (18503) commit_thread: after optimization, 3 locks to release
>> (18503) ERROR at /home/xling/ocfs/ocfs2/src/bitmap.c, 408:
>> bitmap->validbits =3D=20
>> 0 but start =3D 277 and num =3D 1!
>
>Do you get the last message on node 0 or node 1? I'm guessing=20
>node 1,=20
Yes.

>looks like the commit thread is dropping the last reference on=20
>the inode
>(which is fine in and of itself). So you're probably in=20
>delete_inode dumping
>the data for the directory. Can you reproduce this at will?
Yes,  seems it can be reproduced each time.
