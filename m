From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 05 May 2011 16:44:30 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/dlm: Do not migrate resource to
 a node that is leaving the domain
In-Reply-To: <20110505232820.GG17822@wotan.suse.de>
References: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
	<1303859005-29529-3-git-send-email-sunil.mushran@oracle.com>
	<20110505222417.GF17822@wotan.suse.de>
	<4DC32862.3080901@oracle.com>
	<20110505232820.GG17822@wotan.suse.de>
Message-ID: <4DC3365E.20700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/05/2011 04:28 PM, Mark Fasheh wrote:
> On Thu, May 05, 2011 at 03:44:50PM -0700, Sunil Mushran wrote:
>> oops... that's a typo. It should be nodenum. Hey, you do remember
>> o2dlm. ;)
> Lol, glad to know I haven't totally lost it  ;)
>
>
>> That check is superfluous. As in, that nodenum should always be in
>> the domain_map. But we've had that check from before and I'm trying
>> not to rock the boat too much.
> Maybe we should warn on it then?

The more I think about it, the more removal makes sense. But I may
need a shot of whiskey to fortify my resolve. ;)
