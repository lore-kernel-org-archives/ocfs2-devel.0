From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 23 Apr 2009 19:06:46 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: fasten dlm_lock_resource
 hash_table lookups
In-Reply-To: <49EFD1F9.1020009@oracle.com>
References: <200904220605.n3M657YN028817@rgminet15.oracle.com>
	<49EFD1F9.1020009@oracle.com>
Message-ID: <49F04BC6.5040206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

Sunil Mushran wrote:
> Wengang,
>
> When we backport, we like to add bread crumbs so that we can track back
> to the original patch. This helps us in cases where we, say, forget to
> include a patch. Also, we want to retain original authorship.
>
> For example:
> http://oss.oracle.com/git/?p=ocfs2-1.4.git;a=commitdiff;h=174f54db9af7c67a1afaa947aed934b9c80f588c 
>
>
> So don't merge the patches. Add the mainline commit at the top of the
> patch. As 1.2 is svn, ensure the authors name is included in an 
> Authored-by
> tag.
>
Ok, I will follow that for later backports.
> Has it been tested in 1.2?
>
No. Since I think this part(hash_table 
construction/insertions/lookups/destruction) is independent and no 
changes from the original patch,
I didn't test it --only made sure it pass compilation.
well,  you want to test the functionility(correctness) or the performance?

thanks,
wengang.
> Thanks
> Sunil
>
> wengang wang wrote:
>> #backporting the 3 patches at 
>> http://kernel.us.oracle.com/~smushran/srini/ to 1.2.
>>
>> enlarge hash_table capacity to fasten hash_table lookups.
>>
>
