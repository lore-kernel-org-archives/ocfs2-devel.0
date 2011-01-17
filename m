From: Gustavo F. Padovan <padovan@profusion.mobi>
Date: Mon, 17 Jan 2011 14:13:59 -0200
Subject: [Ocfs2-devel]
 =?utf-8?b?W1BhdGNoXSBLaWxsIG9mZiB3YXJuaW5nOiDigJhp?=
 =?utf-8?q?nline=E2=80=99_is_not_at_beginning_of_declaration?=
In-Reply-To: <alpine.LNX.2.00.1101170000270.13377@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101170000270.13377@swampdragon.chaosbits.net>
Message-ID: <20110117161359.GA2885@vigoh>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jesper Juhl <jj@chaosbits.net>
Cc: alsa-devel@alsa-project.org, Mauro Carvalho Chehab <mchehab@redhat.com>, Takashi Iwai <tiwai@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaroslav Kysela <perex@perex.cz>, Jens Axboe <jens.axboe@oracle.com>, Stephen Hemminger <shemminger@vyatta.com>, Andi Kleen <ak@linux.intel.com>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, x86@kernel.org, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@redhat.com>, oprofile-list@lists.sf.net, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Mark Fasheh <mfasheh@suse.com>, Marcel Holtmann <marcel@holtmann.org>, "John W. Linville" <linville@tuxdriver.com>, David Teigland <teigland@redhat.com>, Joel Becker <jlbec@evilplan.org>, Thomas Gleixner <tglx@linutronix.de>, linux-edac@vger.kernel.org, trivial@kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, Greg

* Jesper Juhl <jj@chaosbits.net> [2011-01-17 00:09:38 +0100]:

> Fix a bunch of 
> 	warning: ?inline? is not at beginning of declaration
> messages when building a 'make allyesconfig' kernel with -Wextra.
> 
> These warnings are trivial to kill, yet rather annoying when building with 
> -Wextra.
> The more we can cut down on pointless crap like this the better (IMHO).
> 
> A previous patch to do this for a 'allnoconfig' build has already been 
> merged. This just takes the cleanup a little further.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  arch/x86/oprofile/op_model_p4.c |    2 +-
>  drivers/bluetooth/btusb.c       |    4 ++--
>  drivers/cpuidle/sysfs.c         |    2 +-
>  drivers/edac/i7300_edac.c       |    2 +-
>  fs/ocfs2/dir.c                  |    2 +-
>  kernel/trace/ring_buffer.c      |    2 +-
>  net/ipv6/inet6_hashtables.c     |    2 +-
>  net/mac80211/tx.c               |    2 +-
>  sound/pci/au88x0/au88x0.h       |    4 ++--
>  sound/pci/au88x0/au88x0_core.c  |    4 ++--
>  10 files changed, 13 insertions(+), 13 deletions(-)

For drivers/bluetooth

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
http://profusion.mobi
