From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Oct 2008 19:38:37 +0100
Subject: [Ocfs2-devel] quota for ocfs2 do not warn a exceed for block
	soft-limit	sometimes
In-Reply-To: <1225281889.6589.45.camel@tristan-laptop.cn.oracle.com>
References: <1225281889.6589.45.camel@tristan-laptop.cn.oracle.com>
Message-ID: <20081029183837.GB27407@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

On Wed 29-10-08 20:04:49, tristan.ye wrote:
> since i can not cc you mail address when filing a bug on oss
> bugzilla,just paste the bug description here.
  Thanks.

> Testing env,
> 
> Kernel version:latest linus's mainline 2.6.27
> Testing Nodes:test5/6
> 
> Description:
> 
> Jan,i used your provided quota tools,now it works for me:),currently,i'm
> doing a sanity check for the quota on ocfs2.
> 
> Found a strange thing when comparing with the ext3,the quota sub-system
> sometimes did not warn me a tip when the soft-limit of space usage was
> exceeded.following are the steps to reproduce this issue:
> 
> 1.mkfs.ocfs2 --fs-features=usrquota,grpquota ...  /dev/sdc5
> 
> 2.mount -t ocfs2 -o usrquota,grpquota /dev/sdc5 /quota
> 
> 3.useradd -m quotauser
> 
> 4.setquota -u quotauser 1024 2048 10 20 -a /dev/sdc5
> 
> 5.quotaon -avug
> 
> 6.su - quotauser; cd /quota
> 
> 7. 
> dd if=/dev/zero of=./testfile1 bs=1024 count=1024
> 1024+0 records in
> 1024+0 records out
> 1048576 bytes (1.0 MB) copied, 0.00825239 seconds, 127 MB/s
> 
> dd if=/dev/zero of=./testfile2bs=1024 count=10
> sdc5: warning, user block quota exceeded.
> 10+0 records in
> 10+0 records out
> 10240 bytes (10 kB) copied, 0.000133629 seconds, 76.6 MB/s
> 
> at the first attempt,it successfully warn me a tip:
> sdc5: warning, user block quota exceeded.
> 
> 8.then I REMOVE all the dd created files by 'rm -rf testfile*',and try
> again with the same operations:
> 
>  dd if=/dev/zero of=./testfile1 bs=1024 count=1024
> 1024+0 records in
> 1024+0 records out
> 1048576 bytes (1.0 MB) copied, 0.00831317 seconds, 126 MB/s
> 
> dd if=/dev/zero of=./testfile2 bs=1024 count=10
> 10+0 records in
> 10+0 records out
> 10240 bytes (10 kB) copied, 0.000135853 seconds, 75.4 MB/s
> ***here a warning should be printed to output******
> 
> quota
> Disk quotas for user quotauser (uid 501): 
>      Filesystem  blocks   quota   limit   grace   files   quota   limit
> grace
>       /dev/sdc5    1056*   1024    2048   6days       2     100
> 200   
> 
> is that strange?
  Yup, I see the bug. Thanks for report. I'll fix it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
