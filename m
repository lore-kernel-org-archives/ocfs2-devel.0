From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Apr 22 01:21:47 2004
Subject: [Ocfs2-devel] Patches to fix the OCFS2 bug 54, which cause
	crashin the second mount under kernel 2.6.
Message-ID: <3ACA40606221794F80A5670F0AF15F8404151912@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

I'm using SVN 1.0, and I just use svn up to check out the lastest one,
the problem is still there, kernel panic.It is reported as bug 58.

Attach is the test suite and I sent out some days ago.run make test, or ./basicrw.sh

I copy the call trace from the screen as:
Call Trace:
run_timer_softirq+0xad/0x169
do_softirq+0x95/0x97
do_IRQ+0xdc/0x114
default_idle
rest_iit
common_interrupt
default_idle
rest_init
common_interrupt
default_idle
cpu_idle
start_kernel
unknown_bootoption
Code:Bad EIP value
<0>Kernel panic : Fatal exception in interrupt
In interrupt handler - not syncing


> -----Original Message-----
> From: Mark Fasheh [mailto:mark.fasheh@oracle.com] 
> Sent: 2004��4��22�� 12:37
> To: Ling, Xiaofeng
> Cc: Zhang, Sonic; Ocfs2-Devel
> Subject: Re: [Ocfs2-devel] Patches to fix the OCFS2 bug 54, 
> which cause crashin the second mount under kernel 2.6.
> 
> 
> On Wed, Apr 21, 2004 at 01:40:43PM +0800, Ling, Xiaofeng wrote:
> > although simple mount and remount is ok, But there still have oops 
> > when running my test on 2.6. That seems happened when unload module 
> > after some read/write. see below dmesg:
> Are you running the latest stuff out of SVN? I made some 
> changes to fix some umount issues a couple days ago (also, 
> fixed a bug where we were still destroying the OIN cache even 
> though it's supposed to be gone :)
> 
> Otherwise, it'd be usefull to know what operations caused the 
> inode leak (which may have in turn caused the lockres leak). 
> Usually I figure this out by the tedious task of mounting, 
> doing a single vfs operation, umounting and checking my logs...
> 	--Mark
> 
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com
> 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfsbasictest.tgz
Type: application/x-compressed
Size: 3566 bytes
Desc: ocfsbasictest.tgz
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040422/15c38cd2/ocfsbasictest-0001.bin
