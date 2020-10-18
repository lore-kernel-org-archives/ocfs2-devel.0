From: Greg KH <gregkh@linuxfoundation.org>
Date: Sun, 18 Oct 2020 07:43:32 +0200
Subject: [Ocfs2-devel] [RFC] treewide: cleanup unreachable breaks
In-Reply-To: <20201017160928.12698-1-trix@redhat.com>
References: <20201017160928.12698-1-trix@redhat.com>
Message-ID: <20201018054332.GB593954@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trix@redhat.com
Cc: alsa-devel@alsa-project.org, clang-built-linux@googlegroups.com, linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org, storagedev@microchip.com, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, ath10k@lists.infradead.org, linux-stm32@st-md-mailman.stormreply.com, usb-storage@lists.one-eyed-alien.net, linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org, linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, amd-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org, intel-wired-lan@lists.osuosl.org, industrypack-devel@lists.sourceforge.net, linux-pci@vger.kernel.org, spice-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-media@vger.kernel.org, linux-serial@vger.kernel.org, linux-nfc@lists.01.org, linux-pm@vger.kernel.org, linux-can@vger.kernel.org, linux-block@vger.kernel.org, linux-gpio@vger.kernel.org, xen-devel@lists.xenproject.org, linux-amlogic@lists.infradead.org, openipmi-developer@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, patches@opensource.cirrus.com, bpf@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-power@fi.rohmeurope.com

On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix at redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> This is a upcoming change to clean up a new warning treewide.
> I am wondering if the change could be one mega patch (see below) or
> normal patch per file about 100 patches or somewhere half way by collecting
> early acks.

Please break it up into one-patch-per-subsystem, like normal, and get it
merged that way.

Sending us a patch, without even a diffstat to review, isn't going to
get you very far...

thanks,

greg k-h
