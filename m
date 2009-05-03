From: Jan Kucera <xatrix101@gmail.com>
Date: Sun, 3 May 2009 22:33:18 +0200
Subject: [Ocfs2-devel] Deadlock in dlmmaster.c
Message-ID: <ef67228d0905031333i782ad1efhe532cd555e58b604@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, joel.becker@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi,

I've found some possible deadlock in fs/ocfs2/dlm/dlmmaster.c - version
2.6.28 (probably this code is in newer versions too).
Could someone confirm this? Thank you.


fs/ocfs2/dlm/dlmmaster.c
==================

function dlm_master_request_handler: (res->spinlock <- dlm->master_lock)
-----------------------------------
spin_lock(&res->spinlock); at line 1427
spin_lock(&dlm->master_lock); at line 1475

function dlm_migrate_request_handler: (dlm->master_lock <- res->spinlock)
-------------------------------------------------------
spin_lock(&dlm->master_lock) at line 3036
spin_lock(&res->spinlock); at line 3039



caught by Stanse
(http://iti.fi.muni.cz/stanse/)
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090503/7592bfb1/attachment-0001.html 
