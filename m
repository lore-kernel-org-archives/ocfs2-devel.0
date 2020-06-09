From: Michael Ellerman <patch-notifications@ellerman.id.au>
Date: Tue,  9 Jun 2020 15:58:30 +1000 (AEST)
Subject: [Ocfs2-devel] [PATCH v3 2/5] powerpc: module_[32|64].c: replace
	swap function with built-in one
In-Reply-To: <994931554238042@iva8-b333b7f98ab0.qloud-c.yandex.net>
Message-ID: <49gzvB1bJMz9sSy@ozlabs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Abramov <st5pub@yandex.ru>, vgupta <vgupta@synopsys.com>, benh <benh@kernel.crashing.org>, paulus <paulus@samba.org>, tglx <tglx@linutronix.de>, mingo <mingo@redhat.com>, bp <bp@alien8.de>, hpa <hpa@zytor.com>, x86 <x86@kernel.org>, mark <mark@fasheh.com>, jlbec <jlbec@evilplan.org>, richard <richard@nod.at>, dedekind1 <dedekind1@gmail.com>, "adrian.hunter" <adrian.hunter@intel.com>, gregkh <gregkh@linuxfoundation.org>, "naveen.n.rao" <naveen.n.rao@linux.vnet.ibm.com>, jpoimboe <jpoimboe@redhat.com>, Dave Chinner <dchinner@redhat.com>, "darrick.wong" <darrick.wong@oracle.com>, "ard.biesheuvel" <ard.biesheuvel@linaro.org>, George Spelvin <lkml@sdf.org>, linux-snps-arc <linux-snps-arc@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, ocfs2-devel <ocfs2-devel@oss.oracle.com>, linux-mtd <linux-mtd@lists.infradead.org>, sfr <sfr@canb.auug.org.au>
Cc: malat <malat@debian.org>, "yamada.masahiro" <yamada.masahiro@socionext.com>, npiggin <npiggin@gmail.com>

On Tue, 2019-04-02 at 20:47:22 UTC, Andrey Abramov wrote:
> Replace relaswap with built-in one, because relaswap
> does a simple byte to byte swap.
> 
> Since Spectre mitigations have made indirect function calls more
> expensive, and the default simple byte copies swap is implemented
> without them, an "optimized" custom swap function is now
> a waste of time as well as code.
> 
> Signed-off-by: Andrey Abramov <st5pub@yandex.ru>
> Reviewed by: George Spelvin <lkml@sdf.org>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

Applied to powerpc next, thanks.

https://urldefense.com/v3/__https://git.kernel.org/powerpc/c/bac7ca7b985b72873bd4ac2553b13b5af5b1f08a__;!!GqivPVa7Brio!LocsSQ-zlIql0GWmmMG2Ry4W0wSo1gzfh36_pvi7Zc-ccRgumoV9gaJm3n89_0RPl8Z-mQ$ 

cheers
