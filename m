From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 23 Aug 2018 23:07:02 +0200
Subject: [Ocfs2-devel] [PATCH] fs/ocfs2/dlmglue: lockdep_keys defined
	but not used
In-Reply-To: <20180704095318.19218-1-anders.roxell@linaro.org>
References: <20180704095318.19218-1-anders.roxell@linaro.org>
Message-ID: <CAMuHMdWCyH-E9VA7ihsoXEq4dvLrPjYd01TYot6qja-psVRcog@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: anders.roxell@linaro.org
Cc: mark@fasheh.com, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi Anders,

On Wed, Jul 4, 2018 at 11:54 AM Anders Roxell <anders.roxell@linaro.org> wrote:
> When CONFIG_DEBUG_LOCK_ALLOC isn't enabled lockdep_keys isn't used and
> we get a warning:
> fs/ocfs2/dlmglue.c:99:30: warning: ?lockdep_keys? defined but not used
>     [-Wunused-variable]
>  static struct lock_class_key lockdep_keys[OCFS2_NUM_LOCK_TYPES];
>                               ^~~~~~~~~~~~
> Adding __maybe_unused to the declaration hids the warning.

Thanks for your patcj!

> Fixes: 1cd75cdb8fbb ("ocfs2: make several functions and variables static (and some const)")

Fixes: 480bd56485b77c36 ("ocfs2: make several functions and variables
static (and some const)")

Presumably the branch got rebased?

> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert at linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
