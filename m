From: Jonathan Corbet <corbet@lwn.net>
Date: Mon, 20 Apr 2020 15:43:16 -0600
Subject: [Ocfs2-devel] [PATCH v2 00/33] Documentation fixes for Kernel
	5.8
In-Reply-To: <cover.1586881715.git.mchehab+huawei@kernel.org>
References: <cover.1586881715.git.mchehab+huawei@kernel.org>
Message-ID: <20200420154316.28e42905@lwn.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: kvm@vger.kernel.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-unionfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>, linux-rdma@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>, linux-rockchip@lists.infradead.org, Matthias Kaehlcke <mka@chromium.org>, Sandeep Maheswaram <sanm@codeaurora.org>, linux-media@vger.kernel.org, devicetree@vger.kernel.org, linux-afs@lists.infradead.org, linux-arm-msm@vger.kernel.org, ecryptfs@vger.kernel.org, kvm-ppc@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>, Maxime Ripard <maxime@cerno.tech>, linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>, Yuti Amonkar <yamonkar@cadence.com>, linux-ide@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, freedreno@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org, linux-crypto@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>, linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com

On Tue, 14 Apr 2020 18:48:26 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Patches 1 to 5 contain changes to the documentation toolset:
> 
> - The first 3 patches help to reduce a lot the number of reported
>   kernel-doc issues, by making the tool more smart.
> 
> - Patches 4 and 5 are meant to partially address the PDF
>   build, with now requires Sphinx version 2.4 or upper.
> 
> The remaining patches fix broken references detected by
> this tool:
> 
>         ./scripts/documentation-file-ref-check
> 
> and address other random errors due to tags being mis-interpreted
> or mis-used.
> 
> They are independent each other, but some may depend on
> the kernel-doc improvements.
> 
> PS.: Due to the large number of C/C, I opted to keep a smaller
> set of C/C at this first e-mail (only e-mails with "L:" tag from
> MAINTAINERS file).

OK, I've applied this set, minus #17 which was applied elsewhere.

Thanks,

jon
