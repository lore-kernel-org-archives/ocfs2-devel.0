From: Larry Chen <lchen@suse.com>
Date: Mon, 30 Oct 2017 18:43:08 +0800
Subject: [Ocfs2-devel] activating discontiguous inode block failed
Message-ID: <bd17f8e0-8591-7f43-61b5-9380cc1fda8d@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, every one,

I found that when using ocfs2-test running
activate_discontig_bg.sh -t inode -r 4096 -b 4096 -c 32768 -d $DEVICE -o 
/usr/local/ocfs2-test/log -s pcmk -n cluster /mnt/ocfs
It prompts me "sorry, activated discontiguous inode block group failed"
but after changing the argument of -r option, and execute
activate_discontig_bg.sh -t inode -r 200 -b 4096 -c 32768 -d $DEVICE -o 
/usr/local/ocfs2-test/log -s pcmk -n cluster /mnt/ocfs
It works fine.
And this is the code path:
*

discontig_runner.sh

f_single_runner

f_inodes_test

${DISCONTIG_ACTIVATE_BIN} -t inode ?(activate_discontig_bg.sh)

f_activate_discontig

${CONTIG_BG_FILLER} (fillup_contig_bg.sh)

f_fillup_ibg

$cur_bitmap_total -gt $bitmap_total***======> In the "sorry" case, they 
are both equal to 4096
Does everyone have any idea?
I'm still looking into this exception.

Thanks,
Larry Chen
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171030/3a287f9a/attachment.html 
