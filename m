From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 18 Oct 2020 12:13:35 -0700
Subject: [Ocfs2-devel] [RFC] treewide: cleanup unreachable breaks
In-Reply-To: <20201018185943.GM20115@casper.infradead.org>
References: <20201017160928.12698-1-trix@redhat.com>
	<20201018185943.GM20115@casper.infradead.org>
Message-ID: <45efa7780c79972eae9ca9bdeb9f7edbab4f3643.camel@HansenPartnership.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, trix@redhat.com
Cc: alsa-devel@alsa-project.org, linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, amd-gfx@lists.freedesktop.org, linux-stm32@st-md-mailman.stormreply.com, usb-storage@lists.one-eyed-alien.net, devel@driverdev.osuosl.org, linux-samsung-soc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pm@vger.kernel.org, ath10k@lists.infradead.org, linux-acpi@vger.kernel.org, intel-wired-lan@lists.osuosl.org, industrypack-devel@lists.sourceforge.net, linux-pci@vger.kernel.org, spice-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-media@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-nfc@lists.01.org, linux-serial@vger.kernel.org, linux-can@vger.kernel.org, linux-block@vger.kernel.org, linux-gpio@vger.kernel.org, storagedev@microchip.com, linux-amlogic@lists.infradead.org, openipmi-developer@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, clang-built-linux@googlegroups.com, patches@opensource.cirrus.com, linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-power@fi.rohmeurope.com

On Sun, 2020-10-18 at 19:59 +0100, Matthew Wilcox wrote:
> On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix at redhat.com wrote:
> > clang has a number of useful, new warnings see
> > https://urldefense.com/v3/__https://clang.llvm.org/docs/DiagnosticsReference.html__;!!GqivPVa7Brio!Krxz78O3RKcB9JBMVo_F98FupVhj_jxX60ddN6tKGEbv_cnooXc1nnBmchm-e_O9ieGnyQ$ 
> 
> Please get your IT department to remove that stupidity.  If you
> can't, please send email from a non-Red Hat email address.

Actually, the problem is at Oracle's end somewhere in the ocfs2 list
... if you could fix it, that would be great.  The usual real mailing
lists didn't get this transformation

https://urldefense.com/v3/__https://lore.kernel.org/bpf/20201017160928.12698-1-trix at redhat.com/__;!!GqivPVa7Brio!NmiWnAviK-W40_qdUPlA0nj_3V93JT4nvxkQXFMpa3VECHCIlMQF2wH971BTYeOM38PP6w$ 

but the ocfs2 list archive did:

https://oss.oracle.com/pipermail/ocfs2-devel/2020-October/015330.html

I bet Oracle IT has put some spam filter on the list that mangles URLs
this way.

James
