From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 03 Sep 2009 14:14:41 +0800
Subject: [Ocfs2-devel] [PATCH] add assertions to stuffs with
 purge/unused lockres
In-Reply-To: <13788945-83AC-49B8-ABC7-EA8762F6DDAE@oracle.com>
References: <200908280821.n7S8L8ut026709@rgminet15.oracle.com>
	<4A9F2677.4030406@oracle.com> <4A9F3627.7050407@oracle.com>
	<13788945-83AC-49B8-ABC7-EA8762F6DDAE@oracle.com>
Message-ID: <4A9F5ED1.6000805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

Sunil Mushran wrote:
> It's too intrusive for a debug patch. And big too. Maybe we need this 
> eventually. But for right now, it will be easier if we can narrow down 
> the scope of the issue as quickly as possible.

Ok. I will use the lockres dumping first.

regards,
wengang.
