From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 22 Nov 2016 10:29:52 +0800
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
 direct io
In-Reply-To: <20161117100319.GS28558@mwanda>
References: <20160309102505.GA15030@mwanda> <20161115103330.GL28558@mwanda>
	<20161115103638.GM28558@mwanda>
	<777b2218-d12e-ea96-7e1c-6852c14b71ec@suse.com>
	<20161116104539.GO28558@mwanda>
	<96764e72-b2ff-f788-0452-bf3f8cb6b268@suse.com>
	<20161117100319.GS28558@mwanda>
Message-ID: <c17a6371-aab0-45c6-451b-2aa4e6617d66@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Dan,

It will not cause a real issue. -EAGAIN can be only returned in
__ocfs2_page_mkwrite() path where "locked_page" is NULL, so that
function will return VM_FAULT_NOPAGE before accessing "fsdata".

Thanks,
Junxiao.

On 11/17/2016 06:03 PM, Dan Carpenter wrote:
> On Thu, Nov 17, 2016 at 11:08:08AM +0800, Eric Ren wrote:
>> Hi,
>>
>> On 11/16/2016 06:45 PM, Dan Carpenter wrote:
>>> On Wed, Nov 16, 2016 at 10:33:49AM +0800, Eric Ren wrote:
>>> That silences the warning, of course, but I feel like the code is buggy.
>>> How do we know that we don't hit that exit path?
>> Sorry, I missed your point. Do you mean the below?
>>
>> "1817 goto out_quota; " will free (*wc), but with "ret = 0". Thus, the caller
>> think it's OK to use (*wc), but...
>>
>> Do I understand you correctly?
>>
> 
> It doesn't free it.  It frees "wc" but not "*fsdata".  So it leaves it
> unintialized on that path.  That's the issue, yes.
> 
> It could be that it's impossible to reach that path from here, but it's
> not clear to me.
> 
> regards,
> dan carpenter
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
