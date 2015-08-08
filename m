From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Sat, 8 Aug 2015 07:44:38 -0500
Subject: [Ocfs2-devel] OCFS2 support which architectures and can the
 cluster work under mixed architectures?
In-Reply-To: <55C309E0.6040103@huawei.com>
References: <55C33EFB020000F9000111BC@relay2.provo.novell.com>
	<55C2F021.9010106@oracle.com> <55C309E0.6040103@huawei.com>
Message-ID: <55C5F9B6.3050400@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 08/06/2015 02:16 AM, Joseph Qi wrote:
> On 2015/8/6 13:26, Junxiao Bi wrote:
>> Hi Gang,
>>
>> On 08/06/2015 11:03 AM, Gang He wrote:
>>> Hello guys,
>>>
>>> >From the document(https://oss.oracle.com/projects/ocfs2/), it says that OCFS2 supports x86, x86_64, ia64 and ppc64. I am not sure that this doc is up-to-date, now, OCFS2 supports any other architecture? e.g. s390x?
>>> The second question, since OCFS2 is a cluster FS and support multiple architectures, can a OCFS2 cluster work under a mixed architectures environment? e.g. some nodes are x86, some nodes are ppc64.
>> I think ocfs2 works good on le endian, but maybe not on big endian
>> though i never test it. From the source code, kernel seemed be prepared
>> for big endian, but for tools, maybe not, i found lot of codes reading
>> stuff from disk to memory without conversion in fsck.ocfs2. I am not
>> sure about other tools, so may need do a full check.
>>
> Junxiao is right. Most tools are not taking care the endian conversion.
> They just treat them as little endian which fits x86.
> Maybe we have to do some changes for this.
>

OCFS2 supports big-endian architectures. There has been significant 
effort in making sure that it is big-endian compatible.

Though it is capable of running on mixed architectures, we do not 
recommend it.


-- 
Goldwyn
