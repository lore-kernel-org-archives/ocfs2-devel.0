From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 26 May 2016 16:10:00 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: bump up o2cb network protocol
	version
In-Reply-To: <1464231615-27939-1-git-send-email-junxiao.bi@oracle.com>
References: <1464231615-27939-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20160526231000.GU7633@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 26, 2016 at 11:00:15AM +0800, Junxiao Bi wrote:
> Two new messages are added to support negotiating hb timeout. Stopping
> nodes talking old version to mount as they will cause the negotiation
> fail.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

Btw, you might want to send the whole series again as a whole so Andrew
knows where this is coming from and that it should be bundled with the
protocol changes themselves.

Thanks,
	--Mark

--
Mark Fasheh
