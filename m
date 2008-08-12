From: Jeff Mahoney <jeffm@suse.com>
Date: Tue, 12 Aug 2008 15:37:27 -0400
Subject: [Ocfs2-devel] [PATCH] ocfs2console: Allow ocfs2console
 to	enumerate device mapper devices
In-Reply-To: <20080812192523.GA11744@mail.oracle.com>
References: <48A1A9C7.1080906@suse.com>
	<20080812192523.GA11744@mail.oracle.com>
Message-ID: <48A1E677.4070009@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Joel Becker wrote:
> [Cc'ing ocfs2-tools-devel]
> 
> On Tue, Aug 12, 2008 at 11:18:31AM -0400, Jeff Mahoney wrote:
>>  ocfs2console will currently display device mapper devices as dm-#, where
>>  the number can be dynamic across reboots making it non-obvious which
>>  device the user is using. While LVM volumes aren't safe to use across
>>  physical nodes, they are often used with virtual machines. Many ocfs2
>>  users also use dm-multipath.
>>
>>  This patch refactors partition_info_fill to separate hashing from
>>  enumeration so that it is trivial to add a device-mapper enumerator.
>>
>>  The device mapper enumerator is automatically enabled if libdevmapper
>>  is present at build time. When enabled, it suppresses the dm-# devices
>>  from enumeration. If disabled, the dm-# devices are used instead.
>>
>>  I have a bug report for this (Novell Bugzilla 414756) and it was easy
>>  enough to bang out quickly.
> 
> 	Nice!  I've not played with libdevmapper - I assume that the
> enumerator returns "preferred" names when there are 10 different
> symlinks for the same volume?  :-)

It uses the canonical device mapper names. The symlinks are added by
add-on tools like multipath or LVM. This enumerates the names that
device mapper knows about. It's the same list that "dmsetup ls" would
show, especially since I used that code as a template. :)

So, for example, it won't show you /dev/system/root, but instead will do
/dev/mapper/system-root. I'd have preferred to have the former, but not
so much that I want to teach ocfs2console about every DM add-on out there.

>> +LIBDEVMAPPER_FOUND=
>> +AC_CHECK_HEADER(libdevmapper.h, LIBDEVMAPPER_FOUND=yes,
>> +  [AC_MSG_WARN([libdevmapper.h not found, device-mapper support will not be built])])
>> +AC_SUBST(LIBDEVMAPPER_FOUND)
> 
> 	Please check for the lib too:
> 
> LIBDEVMAPPER_FOUND=
> AC_CHECK_LIB(devmapper, dm_task_create,
>   [AC_CHECK_HEADER(libdevmapper.h, LIBDEVMAPPER_FOUND=yes,
>     [AC_MSG_WARN([libdevmapper.h not found, device-mapper support will not be built])])],
>   [AC_MSG_WARN([libdevmapper not found, device-mapper support will not
> be built])])
> AC_SUBST(LIBDEVMAPPER_FOUND)

Great, thanks for the quick review. I'll fix that up and resend.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkih5ncACgkQLPWxlyuTD7KXDgCfYIjaPKjmJimI1IadFQjzSBof
wHAAmgO3qk1Tglq6Z+bMW0cp2rZu73y2
=OEZR
-----END PGP SIGNATURE-----
