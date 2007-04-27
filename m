From: Jeff Mahoney <jeffm@suse.com>
Date: Fri Apr 27 08:53:12 2007
Subject: [Ocfs2-devel] configfs: possible recursive locking detected
Message-ID: <46321C3F.5060902@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi guys -

I recently rebuilt my mainline kernel with lockdep enabled since I've
been getting reports of reiserfs lockdep warnings. When I booted, I got
the following warning from configfs. I haven't done any triage at all on
it, but one of the shortcomings of lockdep IMO is the false positives.
The ones for reiserfs just need better annotation. There's no error
condition. This might be the same.

- -Jeff


=============================================
[ INFO: possible recursive locking detected ]
2.6.21-rc7-git5-default #6
- ---------------------------------------------
o2cb_ctl/4278 is trying to acquire lock:
 (&sysfs_inode_imutex_key){--..}, at: [<ffffffff8839e865>]
configfs_add_file+0x35/0x66 [configfs]

but task is already holding lock:
 (&sysfs_inode_imutex_key){--..}, at: [<ffffffff8839f400>]
configfs_attach_group+0x58/0x19d [configfs]

other info that might help us debug this:
2 locks held by o2cb_ctl/4278:
 #0:  (&inode->i_mutex/1){--..}, at: [<ffffffff80251580>]
lookup_create+0x23/0x84
 #1:  (&sysfs_inode_imutex_key){--..}, at: [<ffffffff8839f400>]
configfs_attach_group+0x58/0x19d [configfs]

stack backtrace:

Call Trace:
 [<ffffffff80299c5a>] __lock_acquire+0x155/0xbe2
 [<ffffffff8839e865>] :configfs:configfs_add_file+0x35/0x66
 [<ffffffff8029a762>] lock_acquire+0x7b/0x9f
 [<ffffffff8839e865>] :configfs:configfs_add_file+0x35/0x66
 [<ffffffff8025d0d6>] __mutex_lock_slowpath+0xe1/0x263
 [<ffffffff8025e726>] _spin_unlock+0x17/0x20
 [<ffffffff8839e865>] :configfs:configfs_add_file+0x35/0x66
 [<ffffffff8839f333>] :configfs:configfs_attach_item+0x18b/0x200
 [<ffffffff8023d713>] d_rehash+0x23/0x44
 [<ffffffff8839f3c3>] :configfs:configfs_attach_group+0x1b/0x19d
 [<ffffffff8839f4a3>] :configfs:configfs_attach_group+0xfb/0x19d
 [<ffffffff8839f4b1>] :configfs:configfs_attach_group+0x109/0x19d
 [<ffffffff80299673>] trace_hardirqs_on+0x124/0x14f
 [<ffffffff8839fdd0>] :configfs:configfs_mkdir+0x1c7/0x268
 [<ffffffff802ce0c7>] vfs_mkdir+0xdb/0x14b
 [<ffffffff802ce58c>] sys_mkdirat+0x97/0xd8
 [<ffffffff80299673>] trace_hardirqs_on+0x124/0x14f
 [<ffffffff8025e262>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff8025711e>] system_call+0x7e/0x83

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGMhw/LPWxlyuTD7IRAni4AJ4oe8/i3gtqM1Kh+CuRRaph1Q8KEQCbBSAm
HS9dV+tGMmS3YTRpkVdYeSA=
=6/K/
-----END PGP SIGNATURE-----
