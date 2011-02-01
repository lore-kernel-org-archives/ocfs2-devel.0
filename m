From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 01 Feb 2011 15:53:59 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Using macro to set/clear
 *FILLED* flags in info handler.
In-Reply-To: <20110201060124.GB2751@noexit>
References: <1296368761-23043-1-git-send-email-tristan.ye@oracle.com>
	<1296368761-23043-2-git-send-email-tristan.ye@oracle.com>
	<20110131221547.GH23899@wotan.suse.de>
	<20110201011011.GB22580@noexit>
	<20110201030617.GJ23899@wotan.suse.de>
	<20110201060124.GB2751@noexit>
Message-ID: <4D47BC17.50602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, Jan 31, 2011 at 07:06:18PM -0800, Mark Fasheh wrote:
>> On Mon, Jan 31, 2011 at 05:10:12PM -0800, Joel Becker wrote:
>>> On Mon, Jan 31, 2011 at 02:15:47PM -0800, Mark Fasheh wrote:
>>>>> +static inline void __o2info_set_request_filled(struct ocfs2_info_request *req)
>>>>> +{
>>>>> +	req->ir_flags |= OCFS2_INFO_FL_FILLED;
>>>>> +}
>>>>> +
>>>>> +#define o2info_set_request_filled(a) \
>>>>> +		__o2info_set_request_filled((struct ocfs2_info_request *)&(a))
>>>> The macro here (and below) casts it's argument, thus defeating any
>>>> typechecking we would have gotten from the function call. Can you
>>>> pleaseremove the macro, rename the functions (take out the __) and use them
>>>> directly? I know we might then want to deref the i*_req field in the
>>>> handlers below but I don't think that's a big deal for what we gain.
>>> 	I'm not sure what you mean here.  Are you asking for one
>>> set_request_filled() call per info type?
>> Oh, no!
>>
>> I was asking for this:
>>
>> static inline void o2info_set_request_filled(struct ocfs2_info_request *req)
>> {
>> 	req->ir_flags |= OCFS2_INFO_FL_FILLED;
>> }
>>
>> instead of the macro which is defeating type checking.
>
> 	You want the casts or derefs forced in the caller, then?
>
> 	o2info_set_request_filled((struct ocfs2_info_request *)ic);
>
> or:
>
> 	o2info_set_request_filled(&ic->ic_req);
Joel,

    Indeed! and seems it will not be making caller's life that hard;-)


   
   
>
> Joel
>
