From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 30 Jul 2010 09:55:15 +0800
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2/dlm: Add message
 DLM_QUERY_HBREGION
In-Reply-To: <4C51B8E0.1070308@oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<1279929322-9276-7-git-send-email-sunil.mushran@oracle.com>
	<20100728162157.GA3411@laptop.jp.oracle.com>
	<4C505F39.2090706@oracle.com>
	<20100729050307.GB2591@laptop.jp.oracle.com>
	<4C51B8E0.1070308@oracle.com>
Message-ID: <20100730015514.GA2510@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Got your idea. Thanks for explaination!

regards,
wengang.
On 10-07-29 10:22, Sunil Mushran wrote:
> On 07/28/2010 10:03 PM, Wengang Wang wrote:
> >Yes, I can see what you are doing there.
> >But you are comparing twice. I was emphasising "again" :)
> >The bhregions is like a collection. we say collection A is equal to
> >collection B, it can mean the number is equal, and all elements in
> >collection A are all in collection B. So no need to compare each region
> >again.
> 
> Sorry, my example was not correct. What if node sends regions A, B, A
> while the receiving node expects A, B, C. It should not happen.
> But considering we rely on the hb regions being consistent, we can
> never be too careful.
> 
> Agreed, I can come up with another scheme. But here the max
> is small. And in such cases, brute force typically works best.
