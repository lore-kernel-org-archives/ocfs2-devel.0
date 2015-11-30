From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 30 Nov 2015 21:13:37 +0800
Subject: [Ocfs2-devel] [QUESTION] what's lockres
	P000000000000000000000000000000?
In-Reply-To: <20151130113542.GA27988@desktop.apac.novell.com>
References: <20151130113542.GA27988@desktop.apac.novell.com>
Message-ID: <AAFB1FFB-9BC4-404D-9CB1-808D5DCD5B3D@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,

It?s orphan scan lock. For more lock type and format, please refer to fs/ocfs2/ocfs2_lockid.h

Thanks,
Junxiao.
> ? 2015?11?30????7:35?Eric Ren <zren@suse.com> ???
> 
> Hi all,
> 
> I found there is an odd lockres P000000000000000000000000000000 for me, so I'm
> curious about what this lockres stands for?
> 
> 1. #dmesg
> ...
> [ 7657.554057] (ocfs2dc,4061,1):ocfs2_process_blocked_lock:3904 lockres
> P000000000000000000000000000000 blocked
> [ 7657.554059] (ocfs2dc,4061,1):ocfs2_prepare_downconvert:3248 lockres
> P000000000000000000000000000000, level 5 => 0, blocking 5
> [ 7657.554062] (ocfs2dc,4061,1):ocfs2_downconvert_lock:3266 lockres
> P000000000000000000000000000000, level 5 => 0
> [ 7657.554066] (ocfs2dc,4061,1):ocfs2_process_blocked_lock:3928 lockres
> P000000000000000000000000000000, requeue = no.
> [ 7657.554070] (dlm_astd,4062,1):ocfs2_locking_ast:1076 AST fired for
> lockres M0000000000000000011a1800000000, action 3, unlock 0, level 5 =>
> 0
> [ 7657.554073] (dlm_astd,4062,1):ocfs2_locking_ast:1076 AST fired for
> lockres P000000000000000000000000000000, action 3, unlock 0, level 5 =>
> 0
> ...
> 
> 2. n1:/debug/dlm # echo "locate <P000000000000000000000000000000>" |
> debugfs.ocfs2 /dev/sda2 
> debugfs.ocfs2 1.8.2
> debugfs: usage: locate <inode#>
> debugfs: 
> 
> 3. n1:/debug/dlm # echo "stat <P000000000000000000000000000000>" |
> debugfs.ocfs2 /dev/sda2 
> debugfs.ocfs2 1.8.2
> debugfs: stat: Directory entry not found
> '<P000000000000000000000000000000>'
> debugfs: 
> 
> 4. n1:/debug/dlm # echo "locate <M0000000000000000011a1800000000>" |
> debugfs.ocfs2 /dev/sda2 
> debugfs.ocfs2 1.8.2
> debugfs:        72216   /file
> debugfs: 
> 
> I know "M" refter to Metadata, but what's "P" here refer to?
> Any help will be appreciated!
> 
> Thanks,
> Eric
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
