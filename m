From: Massimo Cetra <ctrixk@navynet.it>
Date: Thu, 02 Dec 2010 18:20:56 +0100
Subject: [Ocfs2-devel] disk full when it shouldn't
In-Reply-To: <4CD89E86.5010404@oracle.com>
References: <4CD813D3.4080106@navynet.it> <4CD89E86.5010404@oracle.com>
Message-ID: <4CF7D578.1060201@navynet.it>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Il 09/11/2010 02:06, Tao Ma ha scritto:
> Hi Massimo,
>
> From the output, it seems that you shouldn't meet with ENOSPC problem
> at that time. So when you meet with ENOSPC, could you please do 'sync'
> first(that will sync the metadata to the disk so that stat_sysdir can
> output the real metadata info) and then do stat_sysdir?
>
> btw, you can also try to 'touch' one new file in your ocfs2 volume. So
> if it succeeds, it means that the inode_alloc is ok. Otherwise, your
> inode_alloc has no space. Please also try this test when you meet with
> ENOSPC.

Hi Tao,

As i supposed, the problem arose another time.

Attached you may find the stat_sysdir output.

For the sake of completeness, have to say that:

- The output of df was the following:

# df -i
Filesystem             Inode   IUsati  ILib. IUso% Montato su
[CUT]
/dev/drbd2           9174751 4695156 4479595   52% /var/mail

# df
Filesystem        blocchi di   1K   Usati Disponib. Uso% Montato su
[CUT]
/dev/drbd2            36699004  18780656  17918348  52% /var/mail

The filesystem was not full:

sheet3-1:/var/mail/virtual# dd if=/dev/zero of=TEST bs=1024 count=1024
dd: scrittura di `TEST': No space left on device
1009+0 records in
1008+0 records out
1032192 bytes (1,0 MB) copied, 0,454305 s, 2,3 MB/s
sheet3-1:/var/mail/virtual#


mailq from postfix had the following errors:

       (maildir delivery failed: error writing message: No space left on 
device)
       (maildir delivery failed: error writing message: No space left on 
device)
       (maildir delivery failed: error writing message: No space left on 
device)

A bunch of emails coundn't be delivered.

I temporarily fixed it by removing old emails and the system recovered.

I had another problem on a couple of different servers today and i'm 
investigating to send more informations.

Max




-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: stat_sysdir.txt
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101202/6e3f39b6/attachment-0001.txt 
