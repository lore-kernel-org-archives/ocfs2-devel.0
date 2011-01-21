From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 21 Jan 2011 17:31:30 +0000
Subject: [Ocfs2-devel]
 =?utf-8?b?W1BhdGNoXSBLaWxsIG9mZiB3YXJuaW5nOiDigJhp?=
 =?utf-8?q?nline=E2=80=99_is_not_at_beginning_of_declaration?=
In-Reply-To: <alpine.LNX.2.00.1101170000270.13377@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101170000270.13377@swampdragon.chaosbits.net>
Message-ID: <20110121173130.GD8323@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jesper Juhl <jj@chaosbits.net>
Cc: alsa-devel@alsa-project.org, Mauro Carvalho Chehab <mchehab@redhat.com>, Takashi Iwai <tiwai@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>, "Gustavo F. Padovan" <padovan@profusion.mobi>, Jaroslav Kysela <perex@perex.cz>, Jens Axboe <jens.axboe@oracle.com>, Stephen Hemminger <shemminger@vyatta.com>, Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, Robert Richter <robert.richter@amd.com>, x86@kernel.org, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@redhat.com>, oprofile-list@lists.sf.net, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Mark Fasheh <mfasheh@suse.com>, Marcel Holtmann <marcel@holtmann.org>, "John W. Linville" <linville@tuxdriver.com>, Thomas Gleixner <tglx@linutronix.de>, linux-edac@vger.kernel.orgt

On Mon, Jan 17, 2011 at 12:09:38AM +0100, Jesper Juhl wrote:
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

Acked for fs/ocfs2

Joel

-- 
