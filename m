From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Mon Aug 23 22:42:47 2004
Subject: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause crash after
	some operation
Message-ID: <3ACA40606221794F80A5670F0AF15F8405476E8E@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The current process is=20
ocfs_clear_inode->
ocfs_dismount_volumn->
ocfs_journal_shutdown->
wake_up(&osb->flush_event)
although it seems this can release the lock. but the bug still exist.
The bug is triggered in submit_bh,=20
in kernel, the process is
do_umount->
fsync_super->
ocfs_sync_fs, sync_blockdev, sync_inodes_sb->
ocfs_clear_inode
So I guess the bug is triggered in sync_blockdev before ocfs_clear_inode =
then put that in ocfs_clear_inode is too later.
I've tried to move ocfs_dismount_volumn or ocfs_journal_shutdown to =
ocfs_sync_fs, but that will cause other problems.
and if just put ocfs_commit_cache in it, it's ok.
If you don't want an extra call to ocfs_commit_cache, we need to  find a =
better place to put ocfs_dismount_volumn.

=20

>-----Original Message-----
>From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
>Sent: 2004=C4=EA8=D4=C224=C8=D5 3:17
>To: Ling, Xiaofeng
>Cc: ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause=20
>crash after some operation
>
>On Mon, Aug 23, 2004 at 04:05:57PM +0800, Ling, Xiaofeng wrote:
>> before umount, all the lock shall be released first.
>> this patch can resolve the problem
>This isn't the way we want to handle this. The way it's=20
>supposed to work is
>that the umount process sends a signal to the commit thread to=20
>shutdown and
>then waits on it's last set of checkpoints / releases. I'd=20
>much rather fix
>what's broken than patch over it :)
>
>I'm actually looking at this bug right now and I think it's due to our
>signal handling code...
>	--Mark
>
>>=20
>> ------------------------------------------------
>> Index: super.c
>> =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- super.c (revision 1370)
>> +++ super.c (working copy)
>> @@ -224,6 +224,7 @@
>>     tid_t target;
>>=20
>>     sb->s_dirt =3D 0;
>> +   ocfs_commit_cache(OCFS2_SB(sb));
>>     target =3D=20
>log_start_commit(OCFS2_SB(sb)->journal->k_journal, NULL);
>>     log_wait_commit(OCFS2_SB(sb)->journal->k_journal, target);
>>     return 0;
>> @@ -234,6 +235,7 @@
>>     tid_t target;
>>=20
>>     sb->s_dirt =3D 0;
>> +   ocfs_commit_cache(OCFS2_SB(sb));
>>     if=20
>(journal_start_commit(OCFS2_SB(sb)->journal->k_journal, &target))
>> {
>>         if (wait)
>>             log_wait_commit(OCFS2_SB(sb)->journal->k_journal,
>> Index: journal.c
>> =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- journal.c   (revision 1370)
>> +++ journal.c   (working copy)
>> @@ -61,7 +61,7 @@
>>                    struct inode *inode);
>>  static int ocfs_recover_node(struct _ocfs_super *osb, int node_num);
>>  static int __ocfs_recovery_thread(void *arg);
>> -static int ocfs_commit_cache (ocfs_super * osb);
>> +int ocfs_commit_cache (ocfs_super * osb);
>>  static int ocfs_wait_on_mount(ocfs_super *osb);
>>  static void ocfs_handle_move_locks(ocfs_journal *journal,
>>                    ocfs_journal_handle *handle);
>> @@ -149,7 +149,7 @@
>>   * This is in journal.c for lack of a better place.
>>   *
>>   */
>> -static int ocfs_commit_cache(ocfs_super *osb)
>> +int ocfs_commit_cache(ocfs_super *osb)
>>  {
>>     int status =3D 0, tmpstat;
>>     ocfs_journal * journal =3D NULL;
>>=20
>>=20
>> -------------------
>> Ling Xiaofeng(Daniel)
>>=20
>> Intel China Software Lab.
>> iNet: 8-752-1243
>> 8621-52574545-1243(O)
>>=20
>> xfling@users.sourceforge.net
>> Opinions are my own and don't represent those of my employer=20
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel@oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>--
>Mark Fasheh
>Software Developer, Oracle Corp
>mark.fasheh@oracle.com
>
