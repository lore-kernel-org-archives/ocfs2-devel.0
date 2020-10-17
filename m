From: Joe Perches <joe@perches.com>
Date: Sat, 17 Oct 2020 12:00:01 -0700
Subject: [Ocfs2-devel] [Cocci] [RFC] treewide: cleanup unreachable breaks
In-Reply-To: <alpine.DEB.2.22.394.2010172016370.9440@hadrien>
References: <20201017160928.12698-1-trix@redhat.com>
	<f530b7aeecbbf9654b4540cfa20023a4c2a11889.camel@perches.com>
	<alpine.DEB.2.22.394.2010172016370.9440@hadrien>
Message-ID: <503af4a57ca6daeb3e42a9be136dcd21e6d6e23d.camel@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia.lawall@inria.fr>
Cc: alsa-devel@alsa-project.org, linux-iio@vger.kernel.org, trix@redhat.com, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, amd-gfx@lists.freedesktop.org, linux-amlogic@lists.infradead.org, linux-stm32@st-md-mailman.stormreply.com, usb-storage@lists.one-eyed-alien.net, devel@driverdev.osuosl.org, linux-samsung-soc@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pm@vger.kernel.org, ath10k@lists.infradead.org, cocci <cocci@systeme.lip6.fr>, clang-built-linux@googlegroups.com, intel-wired-lan@lists.osuosl.org, industrypack-devel@lists.sourceforge.net, nouveau@lists.freedesktop.org, spice-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-media@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-nfc@lists.01.org, linux-serial@vger.kernel.org, linux-can@vger.kernel.org, linux-block@vger.kernel.org, linux-gpio@vger.kernel.org, storagedev@microchip.com, xen-devel@lists.xenproject.org, openipmi-developer@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, patches@opensource.cirrus.com, linux-integrity@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-power@fi.rohmeurope.com

On Sat, 2020-10-17 at 20:21 +0200, Julia Lawall wrote:
> On Sat, 17 Oct 2020, Joe Perches wrote:
> > On Sat, 2020-10-17 at 09:09 -0700, trix at redhat.com wrote:
> > > From: Tom Rix <trix@redhat.com>
> > > 
> > > This is a upcoming change to clean up a new warning treewide.
> > > I am wondering if the change could be one mega patch (see below) or
> > > normal patch per file about 100 patches or somewhere half way by collecting
> > > early acks.
> > > 
> > > clang has a number of useful, new warnings see
> > > https://urldefense.com/v3/__https://clang.llvm.org/docs/DiagnosticsReference.html__;!!GqivPVa7Brio!OweNQte1ze8A6iwMcGMIqJE3NFYtN61oTqkVuGY8sbDO7D9ObFTMSGLWLp7KLjYbk-FPpA$ 
> > > 
> > > This change cleans up -Wunreachable-code-break
> > > https://urldefense.com/v3/__https://clang.llvm.org/docs/DiagnosticsReference.html*wunreachable-code-break__;Iw!!GqivPVa7Brio!OweNQte1ze8A6iwMcGMIqJE3NFYtN61oTqkVuGY8sbDO7D9ObFTMSGLWLp7KLjbRHL6P8g$ 
> > > for 266 of 485 warnings in this week's linux-next, allyesconfig on x86_64.
> > 
> > Early acks/individual patches by subsystem would be good.
> > Better still would be an automated cocci script.
> 
> Coccinelle is not especially good at this, because it is based on control
> flow, and a return or goto diverts the control flow away from the break.
> A hack to solve the problem is to put an if around the return or goto, but
> that gives the break a meaningless file name and line number.  I collected
> the following list, but it only has 439 results, so fewer than clang.  But
> maybe there are some files that are not considered by clang in the x86
> allyesconfig configuration.
> 
> Probably checkpatch is the best solution here, since it is not
> configuration sensitive and doesn't care about control flow.

Likely the clang compiler is the best option here.

It might be useful to add -Wunreachable-code-break to W=1
or just always enable it if it isn't already enabled.

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 95e4cdb94fe9..3819787579d5 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -32,6 +32,7 @@ KBUILD_CFLAGS += $(call cc-option, -Wunused-but-set-variable)
 KBUILD_CFLAGS += $(call cc-option, -Wunused-const-variable)
 KBUILD_CFLAGS += $(call cc-option, -Wpacked-not-aligned)
 KBUILD_CFLAGS += $(call cc-option, -Wstringop-truncation)
+KBUILD_CFLAGS += $(call cc-option, -Wunreachable-code-break)
 # The following turn off the warnings enabled by -Wextra
 KBUILD_CFLAGS += -Wno-missing-field-initializers
 KBUILD_CFLAGS += -Wno-sign-compare

(and thank you Tom for pushing this forward)

checkpatch can't find instances like:

	case FOO:
		if (foo)
			return 1;
		else
			return 2;
		break;

As it doesn't track flow and relies on the number
of tabs to be the same for any goto/return and break;

checkpatch will warn on:

	case FOO:
		...
		goto bar;
		break;
