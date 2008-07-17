From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 17 Jul 2008 17:39:01 +0800
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Add extended attribute
 support v2
In-Reply-To: <20080711194754.GA9557@wotan.suse.de>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<20080711194754.GA9557@wotan.suse.de>
Message-ID: <487F1335.4020303@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Mark,

  > I think maybe the easiest thing to do is compute this value at mkfs 
time and
> store it on the superblock?

Do we really need take space(32 bytes) in superblock to store this hash 
value? For the space in superblock is very precious.

Best regards,
tiger
