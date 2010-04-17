From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 16 Apr 2010 18:03:09 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add new OCFS2_IOC_INFO ioctl
	for ocfs2 v6.
In-Reply-To: <20100417001138.GA16236@ca-server1.us.oracle.com>
References: <1271213772-2457-1-git-send-email-tristan.ye@oracle.com>
	<1271213772-2457-2-git-send-email-tristan.ye@oracle.com>
	<4BC8DB8C.3020206@oracle.com> <4BC8E406.2000200@oracle.com>
	<20100417001138.GA16236@ca-server1.us.oracle.com>
Message-ID: <4D0D6C50-58E5-4F25-9948-CAEF36F23596@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Agreed. o2info_from_user() would be one suggestion.

On Apr 16, 2010, at 5:11 PM, Joel Becker <Joel.Becker@oracle.com> wrote:

> On Fri, Apr 16, 2010 at 03:26:14PM -0700, Sunil Mushran wrote:
>> Or, you could take it a step further and make some macros. Keep these
>> macros in close proximity to these functions.
>>
>> #define _ocfs2_from_user(a, b)  \
>>                copy_from_user(&(a), (a), typeof(a))
>>
>> #define _ocfs2_to_user(a, b)    \
>>                copy_to_user((typeof(a) __user *)b, &(a), sizeof(a))
>>
>>        if (_ocfs2_from_user(oic, req))
>>                goto bail;
>>
>>        if (_ocfs2_to_user(oic, req))
>>                goto bail;
>
>    Give them a more specific name; no one should thing they are
> generic c-t-u functions.  ocfs2-info-to-user?  bonus if they handle  
> the
> info types automagically.
>
> Joel
> -- 
>
> "Born under a bad sign.
> I been down since I began to crawl.
> If it wasn't for bad luck,
> I wouldn't have no luck at all."
>
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
