From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 1 Sep 2009 13:25:28 -0700
Subject: [Ocfs2-devel] [PATCH] dlmglue.c: add missed mlog lines
In-Reply-To: <4A97B976.4030506@suse.de>
References: <4A97B976.4030506@suse.de>
Message-ID: <20090901202528.GI2818@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 28, 2009 at 07:03:18PM +0800, Coly Li wrote:
> This patch adds the missed mlog_exit() and mlog_exit_void() lines when routines
> return.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> ---
>  fs/ocfs2/dlmglue.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

Acked-by: Mark Fasheh <mfasheh@suse.com>


--
Mark Fasheh
