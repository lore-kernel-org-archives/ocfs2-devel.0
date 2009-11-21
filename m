From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:46:31 -0800
Subject: [Ocfs2-devel] ocfs2 1.6 - sixth set
In-Reply-To: <20091121014158.GB15987@mail.oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
	<20091121014158.GB15987@mail.oracle.com>
Message-ID: <4B074677.9060102@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Nov 20, 2009 at 05:12:47PM -0800, Sunil Mushran wrote:
>   
> 	It's yucky, but I know what you're doing.  I hope we're going to
> be able to re-enable quotas?
>
>   

No. It requires extensive vfs changes.  Quotas is the only feature we'll
not be able to enable for el5.
