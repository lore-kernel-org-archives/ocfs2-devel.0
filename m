From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 11:27:32 -0800
Subject: [Ocfs2-devel] [PATCH 02/10] ocfs2: Handle missing dlmconstants.h
In-Reply-To: <20091111025956.GC17774@mail.oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
	<1257818413-32014-3-git-send-email-sunil.mushran@oracle.com>
	<20091111025956.GC17774@mail.oracle.com>
Message-ID: <4AFB1024.3050707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> 	Again you're including the kapi-compat header unconditionally.
> Only include it when it is necessary.
>   

Ok.

>   
>> +#ifdef NO_DLMCONSTANTS_HEADER
>> +#include <linux/types.h>
>> +#include <linux/dlm.h>
>>     
>
> Then maybe change this to
>
> #ifndef DLM_LOCK_NL
> # include <linux/dlmconstants.h>
> #endif
>   

Not sure why we need to do this.
