From: Richard Weinberger <richard@nod.at>
Date: Mon, 02 Mar 2015 10:04:23 +0100
Subject: [Ocfs2-devel] [PATCH 1/4 V2] ocfs2: use retval instead of
 status for checking error
In-Reply-To: <20150227234840.GA12922@devel.8.8.4.4>
References: <20150227234840.GA12922@devel.8.8.4.4>
Message-ID: <54F42797.1040908@nod.at>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daeseok Youn <daeseok.youn@gmail.com>, mfasheh@suse.com, akpm@linux-foundation.org
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Am 28.02.2015 um 00:48 schrieb Daeseok Youn:
> The use of 'status' in __ocfs2_add_entry() can return wrong
> status when some functions are failed.
> 
> If ocfs2_journal_access_db() in __ocfs2_add_entry() is failed,
> that status is saved to 'status' but return variable is 'retval'
> which is saved 'success' status. In case of this,  __ocfs2_add_entry()
> is failed but can be returned as 'success'.
> 
> So replace 'status' with 'retval'.

As this patch is untested and the issue is theoretical I'm nervous.
But the final decision is up to ocfs2 maintainers.

Thanks,
//richard
