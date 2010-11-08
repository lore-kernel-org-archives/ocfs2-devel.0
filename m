From: Massimo Cetra <ctrixk@navynet.it>
Date: Mon, 08 Nov 2010 16:14:27 +0100
Subject: [Ocfs2-devel] disk full when it shouldn't
Message-ID: <4CD813D3.4080106@navynet.it>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

i've been using OCFS2 for a while (2 years or so, now) but i still have 
a big problem.

on each filesystem that i have, it happens that, even if df reports that 
the disk has plenty of free space avalaible, no one can write any file.
This behaviour has happened for several usages of OCFS2 (webserver and 
mail storage) so both with big files and small files.

It happens more frequently on the mail partitions that i manage.
I have tried to search for some documentation about this problems and it 
seems that i'm not the only one experiencing this behaviour.

The kernels showing this behaviour are both 2.6.32 and 2.6.31.
This happens with OCFS2-tools 1.4.2 and 1.4.3

In the last weeks i have reformatted some partitions from scratch using 
1.4.3 but the problem persists.

I have found somewhere a bash script to analyze the sysdir and output 
useful informations for the debugging.
The output of this script during the problem is attached.

Any hint about this ?

Thanks,

Max


-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: debugfs.txt
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101108/6a59bcae/attachment-0001.txt 
