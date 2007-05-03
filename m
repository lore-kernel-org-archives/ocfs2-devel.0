From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu May  3 15:18:21 2007
Subject: [Ocfs2-devel] [PATCH] enable building as SUSE KMP
In-Reply-To: <4623BB1C.30101@suse.com>
References: <4623BB1C.30101@suse.com>
Message-ID: <20070503221817.GP27857@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 16, 2007 at 02:06:20PM -0400, Jeff Mahoney wrote:
> With the KMP infrastructure, if allowed, 'make packages' should work without even
> running configure since it runs configure for each kernel it builds against.
> 

Jeff,
	I get this when running on a vanilla SLES10 system:

# make packages
<snipped tar output>
rpmbuild -bs --define "_sourcedir ." --define "_srcrpmdir ."
./vendor/suse-kmp/ocfs2.spec
ln: creating symbolic link `arch/um/Kconfig.arch' to
`/usr/src/linux-2.6.16.21-0.8/arch/um/Kconfig.i386': Permission denied
error: Unable to open temp file.
*** glibc detected *** rpmbuild: free(): invalid pointer: 0xb7efa630 ***
======= Backtrace: =========
/lib/libc.so.6[0xb7b50911]
/lib/libc.so.6(__libc_free+0x84)[0xb7b51f84]
/usr/lib/librpmbuild-4.4.so(writeRPM+0x34a)[0xb7eb707a]
/usr/lib/librpmbuild-4.4.so(packageSources+0x1c1)[0xb7eb8091]
/usr/lib/librpmbuild-4.4.so(buildSpec+0x379)[0xb7eaf139]
rpmbuild[0x804a81e]
rpmbuild[0x804ab3b]
rpmbuild[0x804b923]
/lib/libc.so.6(__libc_start_main+0xdc)[0xb7b0287c]
rpmbuild[0x8049db1]
======= Memory map: ========
08048000-0804d000 r-xp 00000000 08:06 851112     /usr/lib/rpm/rpmb
0804d000-0804e000 rw-p 00004000 08:06 851112     /usr/lib/rpm/rpmb
0804e000-0809e000 rw-p 0804e000 00:00 0          [heap]
b78f5000-b78ff000 r-xp 00000000 08:06 277497     /lib/libgcc_s.so.1
b78ff000-b7900000 rw-p 00009000 08:06 277497     /lib/libgcc_s.so.1
b7900000-b7921000 rw-p b7900000 00:00 0 
b7921000-b7a00000 ---p b7921000 00:00 0 
b7a13000-b7a48000 r--s 00000000 08:06 786650     /var/run/nscd/db4iXNfB
(deleted)
b7a48000-b7a7d000 r--s 00000000 08:06 786649     /var/run/nscd/group
b7a7d000-b7ab2000 r--s 00000000 08:06 786648     /var/run/nscd/passwd
b7ab4000-b7ae7000 r--p 00000000 08:06 685680
/usr/lib/locale/en_US.utf8/LC_CTYPE
b7ae7000-b7ae8000 r--p 00000000 08:06 685673
/usr/lib/locale/en_US.utf8/LC_NUMERIC
b7ae8000-b7ae9000 r--p 00000000 08:06 656068
/usr/lib/locale/en_US.utf8/LC_TIME
b7ae9000-b7aea000 r--p 00000000 08:06 656067
/usr/lib/locale/en_US.utf8/LC_MONETARY
b7aea000-b7aeb000 r--p 00000000 08:06 669744
/usr/lib/locale/en_US.utf8/LC_MESSAGES/SYS_LC_MESSAGES
b7aeb000-b7aec000 r--p 00000000 08:06 685654
/usr/lib/locale/en_US.utf8/LC_PAPER
b7aec000-b7aed000 rw-p b7aec000 00:00 0 
b7aed000-b7c06000 r-xp 00000000 08:06 277459     /lib/libc-2.4.so
b7c06000-b7c08000 r--p 00118000 08:06 277459     /lib/libc-2.4.so
b7c08000-b7c0a000 rw-p 0011a000 08:06 277459     /lib/libc-2.4.so
b7c0a000-b7c0d000 rw-p b7c0a000 00:00 0 
b7c0d000-b7c1d000 r-xp 00000000 08:06 277528     /lib/libbz2.so.1.0.0
b7c1d000-b7c1e000 rw-p 0000f000 08:06 277528     /lib/libbz2.so.1.0.0
b7c1e000-b7c1f000 rw-p b7c1e000 00:00 0 
b7c1f000-b7c30000 r-xp 00000000 08:06 277513     /lib/libz.so.1.2.3
b7c30000-b7c31000 rw-p 00010000 08:06 277513     /lib/libz.so.1.2.3
b7c31000-b7c41000 r-xp 00000000 08:06 277485     /lib/libpthread-2.4.so
b7c41000-b7c43000 rw-p 0000f000 08:06 277485     /lib/libpthread-2.4.so
b7c43000-b7c45000 rw-p b7c43000 00:00 0 
b7c45000-b7c4c000 r-xp 00000000 08:06 277489     /lib/librt-2.4.so
b7c4c000-b7c4e000 rw-p 00006000 08:06 277489     /lib/librt-2.4.so
b7c4e000-b7c50000 r-xp 00000000 08:06 277465     /lib/libdl-2.4.so
b7c50000-b7c52000 rw-p 00001000 08:06 277465     /lib/libdl-2.4.so
b7c52000-b7c75000 r-xp 00000000 08:06 277467     /lib/libm-2.4.so
b7c75000-b7c77000 rw-p 00022000 08:06 277467     /lib/libm-2.4.so
b7c77000-b7c7e000 r-xp 00000000 08:06 626032
/usr/lib/libpopt.so.0.0.0
b7c7e000-b7c7f000 rw-p 00006000 08:06 626032
/usr/lib/libpopt.so.0.0.0
b7c7f000-b7c80000 rw-p b7c7f000 00:00 0 
b7c80000-b7d06000 r-xp 00000000 08:06 440757
/usr/lib/librpmio-4.4.so
b7d06000-b7d0b000 rw-p 00085000 08:06 440757
/usr/lib/librpmio-4.4.so
b7d0b000-b7d2e000 rw-p b7d0b000 00:00 0 
b7d2e000-b7e19000 r-xp 00000000 08:06 440756
/usr/lib/librpmdb-4.4.so
b7e19000-b7e1d000 rw-p 000ea000 08:06 440756
/usr/lib/librpmdb-4.4.so
b7e1d000-b7e73000 r-xp 00000000 08:06 440754     /usr/lib/librpm-4.4.so
b7e73000-b7e76000 rw-p 00055000 08:06 440754     /usr/lib/librpm-4.4.so
b7e76000-b7ea9000 rw-p b7e76000 00:00 0 
b7ea9000-b7ecd000 r-xp 00000000 08:06 440755
/usr/lib/librpmbuild-4.4.so
b7ecd000-b7ecf000 rw-p 00024000 08:06 440755
/usr/lib/librpmbuild-4.4.so
b7ecf000-b7edb000 rw-p b7ecf000 00:00 0 
b7edb000-b7edc000 r--p 00000000 08:06 685647
/usr/lib/locale/en_US.utf8/LC_NAME
b7edc000-b7edd000 r--p 00000000 08:06 656064
/usr/lib/locale/en_US.utf8/LC_ADDRESS
b7edd000-b7ede000 r--p 00000000 08:06 685646
/usr/lib/locale/en_US.utf8/LC_TELEPHONE
b7ede000-b7edf000 r--p 00000000 08:06 685648
/usr/lib/locale/en_US.utf8/LC_MEASUREMENT
b7edf000-b7ee6000 r--s 00000000 08:06 655372
/usr/lib/gconv/gconv-modules.cache
b7ee6000-b7ee7000 r--p 00000000 08:06 656065
/usr/lib/locale/en_US.utf8/LC_IDENTIFICATION
b7ee7000-b7ee8000 rw-p b7ee7000 00:00 0 
b7ee8000-b7f02000 r-xp 00000000 08:06 277452     /lib/ld-2.4.so
b7f02000-b7f04000 rw-p 00019000 08:06 277452     /lib/ld-2.4.so
bfe41000-bfe92000 rw-p bfe41000 00:00 0          [stack]
ffffe000-fffff000 ---p 00000000 00:00 0          [vdso]
make: *** [srpm] Aborted (core dumped)

	I have a hunch the "Permission denied" is because I ran as
myself.  Do KMP packages have to be built as root?

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
