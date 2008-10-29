From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 29 Oct 2008 14:59:39 -0700
Subject: [Ocfs2-devel] [Fwd: How do I printk <type> correctly?]
Message-ID: <20081029215939.GG15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Folks,

	Please read the below post - I keep having to fix up printk-related
build warnings, usually because I miss them on x86_64, then someone builds
on ia64 or ppc, etc and e-mails me. This is trivial to avoid though - we
keep making the same mistake:

{
	u64 block;
	printk("block: %llu\n", block);
}


That code above will generate a warning similar to:
fs/ocfs2/xxx.c:lineo: warning: long long unsigned int format, u64 arg (arg X)

Instead, you must always cast 'u64' and 's64' to whatever you're asking
printk to print. For example, the correct form of the above example would
be:

{
	u64 block;
	printk("block: %llu\n", (unsigned long long)block);
}


There's more regarding size_t, s64, etc below.
	--Mark

----- Forwarded message from Alexey Dobriyan <adobriyan@gmail.com> -----

Date:	Thu, 23 Oct 2008 15:41:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel at vger.kernel.org
Subject: How do I printk <type> correctly?
User-Agent: Mutt/1.5.18 (2008-05-17)

If variable is of Type	use	printk format specifier.
---------------------------------------------------------
		int			%d or %x
		unsigned int		%u or %x
		long			%ld ot %lx
		unsigned long		%lu or %lx
		long long		%lld or %llx
		unsigned long long	%llu or %llx
		size_t			%zu or %zx
		ssize_t			%zd or %zx

Raw pointer value SHOULD be printed with %p.

u64 SHOULD be printed with %llu/%llx, (unsigned long long):

	printk("%llu", (unsigned long long)u64_var);

s64 SHOULD be printed with %lld/%llx, (long long):

	printk("%lld", (long long)s64_var);

If type is dependent on config option (sector_t), use format specifier
of biggest type and explicitly cast to it.

Reminder: sizeof() result is of type size_t.

Thank you for your cooperation.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo at vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----
--
Mark Fasheh
