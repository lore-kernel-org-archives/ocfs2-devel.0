From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Apr 21 23:37:28 2004
Subject: [Ocfs2-devel] Patches to fix the OCFS2 bug 54, which cause
	crashin the second mount under kernel 2.6.
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404151384@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F8404151384@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040422043723.GK10471@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 21, 2004 at 01:40:43PM +0800, Ling, Xiaofeng wrote:
> although simple mount and remount is ok, But there still have oops when running my test on 2.6.
> That seems happened when unload module after some read/write.
> see below dmesg:
Are you running the latest stuff out of SVN? I made some changes to fix some
umount issues a couple days ago (also, fixed a bug where we were still
destroying the OIN cache even though it's supposed to be gone :)

Otherwise, it'd be usefull to know what operations caused the inode leak
(which may have in turn caused the lockres leak). Usually I figure this out
by the tedious task of mounting, doing a single vfs operation, umounting and
checking my logs...
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
