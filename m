From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Aug 24 13:07:12 2004
Subject: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause crash after
	some operation
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8405476E8E@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8405476E8E@pdsmsx403>
Message-ID: <20040824180708.GA1094@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Tue, Aug 24, 2004 at 11:42:44AM +0800, Ling, Xiaofeng wrote:
> The current process is 
> ocfs_clear_inode->
> ocfs_dismount_volumn->
> ocfs_journal_shutdown->
> wake_up(&osb->flush_event)
> although it seems this can release the lock. but the bug still exist.
> The bug is triggered in submit_bh, 
> in kernel, the process is
> do_umount->
> fsync_super->
> ocfs_sync_fs, sync_blockdev, sync_inodes_sb->
> ocfs_clear_inode
> So I guess the bug is triggered in sync_blockdev before ocfs_clear_inode then put that in ocfs_clear_inode is too later.
> I've tried to move ocfs_dismount_volumn or ocfs_journal_shutdown to ocfs_sync_fs, but that will cause other problems.
> and if just put ocfs_commit_cache in it, it's ok.
> If you don't want an extra call to ocfs_commit_cache, we need to  find a better place to put ocfs_dismount_volumn.
 
Do you have a kernel stack trace? I want to make sure we're talking about
the same bug (s) here. The 1st one I dealt with was only that commit thread
was trying to release the locks with a signal pending which caused the code
in dlm.c to freak out. I removed signal handling from it altogether and just
use our ocfs_wait function instead. This seemed to alleviate that problem.
Issue #2 I see during umount is that occasionally the ocfs2 nm thread will 
crash in __make_request:

------------[ cut here ]------------
kernel BUG at ll_rw_blk.c:1014!
invalid operand: 0000
ocfs2 nfs lockd sunrpc parport_pc lp parport netconsole autofs tg3 floppy sg
loo
p lvm-mod keybdev mousedev hid input usb-uhci usbcore ext3 jbd qla2300
aic7xxx
CPU:    6
EIP:    0060:[<c01ccad1>]    Not tainted
EFLAGS: 00010246

EIP is at __make_request [kernel] 0x81 (2.4.21-15.ELsmp/i686)
eax: 00000800   ebx: 00000000   ecx: 00000b40   edx: 00000008
esi: f3cbceec   edi: f6285618   ebp: 00000b40   esp: c6f6fdc4
ds: 0068   es: 0068   ss: 0068
Process ocfs2nm-0 (pid: 9164, stackpage=c6f6f000)
Stack: f6285600 c0435180 00000006 c53ee000 c6f6fe18 c0123274 c0436680
c6f6e000 
       c53ee000 000000ff 00000800 f6285640 c6f6e000 c0436680 00000000
00000008 
       00000b40 00000006 f3cbceec 00000008 013fe5b9 00000b40 c01cd22a
f6285618 
Call Trace:   [<c0123274>] schedule [kernel] 0x2f4 (0xc6f6fdd8)
[<c01cd22a>] generic_make_request [kernel] 0xea (0xc6f6fe1c)
[<c01cd2c9>] submit_bh_rsector [kernel] 0x49 (0xc6f6fe44)
[<f8b05bbd>] ocfs_read_bhs [ocfs2] 0x641 (0xc6f6fe60)
[<c013334b>] del_timer_sync [kernel] 0x1b (0xc6f6fe94)
[<f8b1c418>] ocfs_volume_thread [ocfs2] 0x25c (0xc6f6fec0)
[<c0122450>] load_balance [kernel] 0x30 (0xc6f6ff0c)
[<c013dd94>] clear_page_tables [kernel] 0x64 (0xc6f6ff24)
[<c0123274>] schedule [kernel] 0x2f4 (0xc6f6ff4c)
[<c012c4c1>] exit_notify [kernel] 0x121 (0xc6f6ff70)
[<c012c9c0>] do_exit [kernel] 0x370 (0xc6f6ff90)
[<f8b1c1bc>] ocfs_volume_thread [ocfs2] 0x0 (0xc6f6ffe0)
[<c010958d>] kernel_thread_helper [kernel] 0x5 (0xc6f6fff0)

Code: 0f 0b f6 03 7c d4 2b c0 89 74 24 08 89 5c 24 04 89 3c 24 e8

I'm still trying to track this one down. If we're still not on the same
page, some more explanation would be helpfull :) Thanks,
	--Mark
>  
> 
> >-----Original Message-----
> >From: Mark Fasheh [mailto:mark.fasheh@oracle.com] 
> >Sent: 2004??8??24?? 3:17
> >To: Ling, Xiaofeng
> >Cc: ocfs2-devel@oss.oracle.com
> >Subject: Re: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause 
> >crash after some operation
> >
> >On Mon, Aug 23, 2004 at 04:05:57PM +0800, Ling, Xiaofeng wrote:
> >> before umount, all the lock shall be released first.
> >> this patch can resolve the problem
> >This isn't the way we want to handle this. The way it's 
> >supposed to work is
> >that the umount process sends a signal to the commit thread to 
> >shutdown and
> >then waits on it's last set of checkpoints / releases. I'd 
> >much rather fix
> >what's broken than patch over it :)
> >
> >I'm actually looking at this bug right now and I think it's due to our
> >signal handling code...
> >	--Mark
> >
> >> 
> >> ------------------------------------------------
> >> Index: super.c
> >> ===================================================================
> >> --- super.c (revision 1370)
> >> +++ super.c (working copy)
> >> @@ -224,6 +224,7 @@
> >>     tid_t target;
> >> 
> >>     sb->s_dirt = 0;
> >> +   ocfs_commit_cache(OCFS2_SB(sb));
> >>     target = 
> >log_start_commit(OCFS2_SB(sb)->journal->k_journal, NULL);
> >>     log_wait_commit(OCFS2_SB(sb)->journal->k_journal, target);
> >>     return 0;
> >> @@ -234,6 +235,7 @@
> >>     tid_t target;
> >> 
> >>     sb->s_dirt = 0;
> >> +   ocfs_commit_cache(OCFS2_SB(sb));
> >>     if 
> >(journal_start_commit(OCFS2_SB(sb)->journal->k_journal, &target))
> >> {
> >>         if (wait)
> >>             log_wait_commit(OCFS2_SB(sb)->journal->k_journal,
> >> Index: journal.c
> >> ===================================================================
> >> --- journal.c   (revision 1370)
> >> +++ journal.c   (working copy)
> >> @@ -61,7 +61,7 @@
> >>                    struct inode *inode);
> >>  static int ocfs_recover_node(struct _ocfs_super *osb, int node_num);
> >>  static int __ocfs_recovery_thread(void *arg);
> >> -static int ocfs_commit_cache (ocfs_super * osb);
> >> +int ocfs_commit_cache (ocfs_super * osb);
> >>  static int ocfs_wait_on_mount(ocfs_super *osb);
> >>  static void ocfs_handle_move_locks(ocfs_journal *journal,
> >>                    ocfs_journal_handle *handle);
> >> @@ -149,7 +149,7 @@
> >>   * This is in journal.c for lack of a better place.
> >>   *
> >>   */
> >> -static int ocfs_commit_cache(ocfs_super *osb)
> >> +int ocfs_commit_cache(ocfs_super *osb)
> >>  {
> >>     int status = 0, tmpstat;
> >>     ocfs_journal * journal = NULL;
> >> 
> >> 
> >> -------------------
> >> Ling Xiaofeng(Daniel)
> >> 
> >> Intel China Software Lab.
> >> iNet: 8-752-1243
> >> 8621-52574545-1243(O)
> >> 
> >> xfling@users.sourceforge.net
> >> Opinions are my own and don't represent those of my employer 
> >> _______________________________________________
> >> Ocfs2-devel mailing list
> >> Ocfs2-devel@oss.oracle.com
> >> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >--
> >Mark Fasheh
> >Software Developer, Oracle Corp
> >mark.fasheh@oracle.com
> >
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
