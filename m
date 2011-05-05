From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 5 May 2011 15:12:58 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/dlm: Add new dlm message
	DLM_BEGIN_EXIT_DOMAIN_MSG
In-Reply-To: <1303859005-29529-2-git-send-email-sunil.mushran@oracle.com>
References: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
	<1303859005-29529-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110505221258.GE17822@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 26, 2011 at 04:03:24PM -0700, Sunil Mushran wrote:
> This patch adds a new dlm message DLM_BEGIN_EXIT_DOMAIN_MSG and ups the dlm
> protocol to 1.2.
> 
> o2dlm sends this new message in dlm_unregister_domain() to mark the beginning
> of the exit domain. This message is sent to all nodes in the domain.
> 
> Currently o2dlm has no way of informing other nodes of its impending exit.
> This information is useful as the other nodes could disregard the exiting
> node in certain operations. For example, in resource migration. If two or
> more nodes were umounting in parallel, it would be more efficient if o2dlm
> were to choose a non-exiting node to be the new master node rather than an
> exiting one.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Looks good, glad we're checking proto versions before sending the message ;)
	--Mark

--
Mark Fasheh
