From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 21 Jan 2015 17:12:06 -0800
Subject: [Ocfs2-devel] ocfs2: should not use le32_add_cpu to set
	ocfs2_dinode i_flags
In-Reply-To: <54C04D64.80501@huawei.com>
References: <54BFE80E.7090002@oracle.com> <54C04D64.80501@huawei.com>
Message-ID: <54C04E66.4090506@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, understood. Thanks for explaining :)


On 01/21/2015 05:07 PM, Joseph Qi wrote:
> Hi Srini,
>
> On 2015/1/22 1:55, Srinivas Eeda wrote:
>> Hi Joesph,
>>
>> thanks a lot for submitting the above patch. I am trying to understand what kind of flag corruption have you noticed and under what circumstances ? I agree with the patch that bitwise operations are better than adding, but I am not able to understand the corruption it could cause. Can you please share!
>>
> Suppose a the following case:
> The dinode i_flag already has the OCFS2_ORPHANED_FL bit set, and calling
> le32_add_cpu again. Then it will corrupt the i_flag.
>
> --
> Joseph
>
>> Thanks,
>> --Srini
>>
>>
>>
>
