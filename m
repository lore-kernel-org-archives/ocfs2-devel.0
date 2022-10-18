Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03B3C433FE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Oct 2022 10:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FqA0KpXVNFho3+vCS6lTJmP2WDBXdWEA6y8bhyC2DGQ=;
 b=NWDHmHdkSrTYnOMSlPVHzQzMlsyyIpTMSmHVH+Hfm/2Pyw/pDkDagd0bsEiIeug5LxEVXEPJ5l0F
   OiU37CTFb5+NtnlIX/0b0PSWyIbQnKFOJ3LXv/HuCH8h8UCVTAaoHi2HmqqdKhSxIOljJv1P772f
   wQGF/GZIgmUHV8XdqP10IsuJnpcilu1qyCWb+V/j9Q6OCjHeJFifHAdCyhjm+4OspLdXNM8z+HC6
   WwAU/kFXeJjNvcy1Ex2unCjSjzM1o/WF7745FqCVe4ypB8gD8dSbQ9mqKZJwCEYfXfw6AMfoKE/o
   G84IKfkwSDQWMdAEr4p8nJl2NyjoOgIhfLi1OQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FqA0KpXVNFho3+vCS6lTJmP2WDBXdWEA6y8bhyC2DGQ=;
 b=rJWx0X/3DkWZMfsHKZCC45da7fZTFxsBlKjuEWvnAk3FhdIWaf6ntExo7L6yMjzmZonK+prHFY6J
   F/mgeYN86Y7rfdxzVLQwCskCC9Xx6OVrLO9d+qGZxzYXL3cDDyM2libNGTuVvu20apUh3JSnqKtc
   raPz+K7eZp/EC0D8rDa5WuxtNsg4YIe/u4VMEQdJsys7Tqgf3QXdDxBNIEfhCktL3OihI0VaZOwq
   tTQ07lUD7yq+FQnRQyfwuKQxn/oLuuo7+TAY4Fl2rKEbMSMgQKNnNdj5dgwc+VpBJxuOGw8uVFKE
   DLGLl6ZDs3uJVxPfE7iIp8bmQWkDMG9Cu62d0w==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJY003R92ODUU20@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Oct 2022 10:33:49 +0000 (GMT)
To: Joseph Qi <joseph.qi@linux.alibaba.com>, <linux-kernel@vger.kernel.org>,
 <ocfs2-devel@oss.oracle.com>
References: <20221018075213.736562-1-yangyingliang@huawei.com>
 <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
Message-id: <09bb2844-e20a-98e8-c2af-5b6c4795d48e@huawei.com>
Date: Tue, 18 Oct 2022 18:33:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10503
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 clxscore=-7 spamscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180060 domainage_hfrom=8316
Cc: gregkh@linuxfoundation.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: possible memory leak in
	mlog_sys_init()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Yang Yingliang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yang Yingliang <yangyingliang@huawei.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: EDytbYgewkzfxwD0YMzKFRQsSRMgt9Pk
X-Proofpoint-ORIG-GUID: EDytbYgewkzfxwD0YMzKFRQsSRMgt9Pk
Reporting-Meta:
 AAF0sge/DxeL+ajRIX3a+Xr7VuAs676It3pV/ZQ35FfStMpKBDCbmJ7BKO2aQsmF
 u2FdibheUjeddm92LWX+mIcPZTFGrn8D/gMiymlTJQA1+TaZGgvWom4Q5jcKeesn
 GP04DI6xg3gLfAD5/Bs+/nOh57vWmn7hmlC5h/pzMrw9O7Rz14EwzDxTGp4Xy9mS
 LfcIg9dXwRi1H9A/dzbudoilsNTuTqo/p+tV81XhQ9Y/oKrrXh++VJ9xmJvNIupI
 57rwc9O5Pakie0nw+Gj45wYiuUUc/6RTgq1pTed30Zyr6pRup/sCMw74nB88+eIe
 NgRySg0LYnE8MdF+sKmioT01pE4Vr32XtQ+6tulqQB/aAiAPTInAPxmPeEeoLO+x
 UWMydfK9Ff4I00O/t+phZ2T2+Phrn2u5JF7JuDEwbXvsSCnx/Edx47zSTSV6JlGV
 RCzXqq9BLy5rQPbRN7kEf/DrEFLn4BZffftKxPlSFmBn+GSOAWCUPnUrftU9v17n
 UA0Y3D5zNg9CertCc9Ngb5CcT05aa1eQu3she3tplrdk/w==

Hi,

On 2022/10/18 17:02, Joseph Qi wrote:
> Hi,
>
> On 10/18/22 3:52 PM, Yang Yingliang wrote:
>> Inject fault while probing module, kset_register() may fail,
>> if it fails, but the refcount of kobject is not decreased to
>> 0, the name allocated in kobject_set_name() is leaked. Fix
>> this by calling kset_put(), so that name can be freed in
>> callback function kobject_cleanup().
>>
>> unreferenced object 0xffff888100da9348 (size 8):
>>    comm "modprobe", pid 257, jiffies 4294701096 (age 33.334s)
>>    hex dump (first 8 bytes):
>>      6c 6f 67 6d 61 73 6b 00                          logmask.
>>    backtrace:
>>      [<00000000306e441c>] __kmalloc_node_track_caller+0x44/0x1b0
>>      [<000000007c491a9e>] kstrdup+0x3a/0x70
>>      [<0000000015719a3b>] kstrdup_const+0x63/0x80
>>      [<0000000084e458ea>] kvasprintf_const+0x149/0x180
>>      [<0000000091302b42>] kobject_set_name_vargs+0x56/0x150
>>      [<000000005f48eeac>] kobject_set_name+0xab/0xe0
>>
>> Fixes: 34980ca8faeb ("Drivers: clean up direct setting of the name of a kset")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   fs/ocfs2/cluster/masklog.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
>> index 563881ddbf00..7f9ba816d955 100644
>> --- a/fs/ocfs2/cluster/masklog.c
>> +++ b/fs/ocfs2/cluster/masklog.c
>> @@ -156,6 +156,7 @@ static struct kset mlog_kset = {
>>   int mlog_sys_init(struct kset *o2cb_kset)
>>   {
>>   	int i = 0;
>> +	int ret;
>>   
>>   	while (mlog_attrs[i].attr.mode) {
>>   		mlog_default_attrs[i] = &mlog_attrs[i].attr;
>> @@ -165,7 +166,11 @@ int mlog_sys_init(struct kset *o2cb_kset)
>>   
>>   	kobject_set_name(&mlog_kset.kobj, "logmask");
>>   	mlog_kset.kobj.kset = o2cb_kset;
>> -	return kset_register(&mlog_kset);
>> +	ret = kset_register(&mlog_kset);
> If register fails, it will call unregister in o2cb_sys_init(), which
> will put kobject.
They are different ksets, the kset unregistered in o2cb_sys_init() is 
'o2cb_kset', the
kset used to registered in mlog_sys_init() is 'mlog_kset', and they hold 
difference
refcounts.

Thanks,
Yang
>
> Thanks,
> Joseph
>
>> +	if (ret)
>> +		kset_put(&mlog_kset);
>> +
>> +	return ret;
>>   }
>>   
>>   void mlog_sys_shutdown(void)
> .

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
