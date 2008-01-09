From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jan  9 11:09:37 2008
Subject: [Ocfs2-devel] [PATCH 1/1] Change default value for o2net and
	heartbeat.
In-Reply-To: <20080109025432.GA14956@tma-pc1.cn.oracle.com>
References: <20080109025432.GA14956@tma-pc1.cn.oracle.com>
Message-ID: <20080109190933.GD23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 09, 2008 at 10:54:32AM +0800, tao.ma wrote:
> The default value for o2net and heartbeat have been changed
> in the newest o2cb configure(ocfs2-tools).
> So change it also in kernel.

Thanks Tao, but this is already in Ocfs2.git:

http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2.git;a=commitdiff;h=a4372b59334d2e7d0ef89eafb8af8d0eedfcf984
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
