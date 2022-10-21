Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A6FC4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 08:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XCMl91FJwAVZS5A41IUlWcDNrlFT4A09HaFGUwECUrA=;
 b=SAVGoyc/Jelm/rxAb5A9FD2vWy4FfMsekxQAESB5fTIK/anOCHIwx/dOXdebpAkE3qwLPxTFT+Zo
   zXqG29iHvjLgHP0Q4ZOdRqJA/ik3SXbVSHu2L0x4moXvXxx9L7WKW7xutLWZ8erlW2PdcBb/miiA
   Ss3mlziptlPAjMDkjsVhOIAL7tq+828l6KA2rwMFS7VakF7WmJA8ddoKAFJRRBo+Lr/zBLnpfmc1
   IRbI6RXNbMhVkqZJFH+eDwcrQ/5C/VAc/lqd0SoNTWOUnwbdZA99jKZr0YfNCnNaEDXfz70T1J/s
   dopb1mEonYFQIJ054xZ0FSagaDOJtEuFbQNHaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XCMl91FJwAVZS5A41IUlWcDNrlFT4A09HaFGUwECUrA=;
 b=EaVxlgRbYncXviVZTSmW/90yda5aEOmIR2BmYGF8W0HcIUCJ+u9BWxGrZe0eVQDUu55AduXdu9/G
   /b/6ksYF+i5hJgBzh+JjlJ28G56Gwy37uEp/aQYusPIsDB6iWi4sn9+KKTpyyVXYXZx2qG/L38u+
   SGBQpIb5S8hRgd+bLftYoe+Efk+yQBe3FgDUV7Z79ptdvDZJVTiFd7HbHjWGAIe74MVRKf8qBSj/
   8hIdtOCa/vL/8XaRUVbTEbReolVZhodaqIF/OtTIlyA34uJdj7BHRgoWP7O384klvib13wcm42NY
   Ozl7akWi2/zDK9X5bckZLacUmF+eFYeGgRmHng==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK3008QGGFFG710@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 08:18:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1666340313; bh=8++5V96CRoT3offEW1sfGPjlBhG5kCvkZ9nTWWOETBI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=jgzWKnVMDL4jjfh3rpyIZnQ6lzYGvVQFOfB2Sz0ckbK8TSaMML0PB6ejva6LPIpVh
 ec2TKJYGoaFx30SX5W4+m5zVlvfmFnd1+qS08e2EpH9AWzJBI41sDGDR+b9qaC68rY
 UySyAc400Lqb6/UqLIyGB/GHeIBa76ZzCFASzYBo=
Date: Fri, 21 Oct 2022 10:18:31 +0200
To: Luben Tuikov <luben.tuikov@amd.com>
Message-id: <Y1JV1wxf/7ERAMhl@kroah.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com> <Y1IwLOUGayjT9p6d@kroah.com>
 <5efd73b0-d634-d34f-3d7a-13d674e40d04@amd.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <5efd73b0-d634-d34f-3d7a-13d674e40d04@amd.com>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 priorityscore=491 phishscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 clxscore=140 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210048
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com,
 linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at,
 mst@redhat.com, amd-gfx@lists.freedesktop.org,
 Yang Yingliang <yangyingliang@huawei.com>, hsiangkao@linux.alibaba.com,
 somlo@cmu.edu, chao@kernel.org, jaegeuk@kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 alexander.deucher@amd.com, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 00/11] fix memory leak while	kset_register()
 fails
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
From: Greg KH via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg KH <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 686jFMbVZZRqvIwxUAt6WzGWQ6OkButm
X-Proofpoint-ORIG-GUID: 686jFMbVZZRqvIwxUAt6WzGWQ6OkButm
Reporting-Meta:
 AAF6ik5wP3qMs0PJ5oXw5GNlhF5mJJ4KlSj1vwCx5XKTaI8XySHzbjmc008daxcU
 4jK1Q+v15Krm9lovAyopCljU1+RhICzTzYw6p9wfOdiU/dmeP4pk1oUa4C/OzdT1
 kIIaNQ9hnWWmjhHHcdOf5NEX7B8DcRMZyCDPH/UtfU6+k4dbbkPfEskiPvUHWc2v
 6Fh4+ek+VttMyMK2+Qi+vziBWmKyzu6BoAEoTm3MOoV0cHPJLwYji5mKwMT2hypx
 5lh8G/ebc9hkf4h9Rh4JuucWR+hiuzT8wqjE9Q1TubNOyM06f7NeKoCMl7sUIDna
 a0yBmN8FYAtqNfbj9oLX2erhLEcKJvR+Myj9WFtpqnfTOWTDDCakHabKvc44oCmi
 8zWpqVEjm0pEgOt3/BS2XtnPYNVRVNQY+SjdB5up4ax7cO4yyMg6oSMYoXZY5Qxq
 /zE50+QJ6WvOBbd1QTXMRGGxk+KOfceQE8LATHZn+eft7AcgOH6exlADjrSwS+9/
 IQA8v6GBS9APoj7DDZpiwEleiSsCqadQ5M3vL5t6AjY=

On Fri, Oct 21, 2022 at 03:55:18AM -0400, Luben Tuikov wrote:
> On 2022-10-21 01:37, Greg KH wrote:
> > On Fri, Oct 21, 2022 at 01:29:31AM -0400, Luben Tuikov wrote:
> >> On 2022-10-20 22:20, Yang Yingliang wrote:
> >>> The previous discussion link:
> >>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F0db486eb-6927-927e-3629-958f8f211194%40huawei.com%2FT%2F&amp;data=05%7C01%7Cluben.tuikov%40amd.com%7C65b33f087ef245a9f23708dab3264840%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638019274318153227%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=1ZoieEob62iU9kI8fvpp20qGut9EeHKIHtCAT01t%2Bz8%3D&amp;reserved=0
> >>
> >> The very first discussion on this was here:
> >>
> >> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Fdri-devel%2Fmsg368077.html&amp;data=05%7C01%7Cluben.tuikov%40amd.com%7C65b33f087ef245a9f23708dab3264840%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638019274318153227%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=9joWxGLUxZZMvrfkxCR8KbkoXifsqoMK0vGR%2FyEG62w%3D&amp;reserved=0
> >>
> >> Please use this link, and not the that one up there you which quoted above,
> >> and whose commit description is taken verbatim from the this link.
> >>
> >>>
> >>> kset_register() is currently used in some places without calling
> >>> kset_put() in error path, because the callers think it should be
> >>> kset internal thing to do, but the driver core can not know what
> >>> caller doing with that memory at times. The memory could be freed
> >>> both in kset_put() and error path of caller, if it is called in
> >>> kset_register().
> >>
> >> As I explained in the link above, the reason there's
> >> a memory leak is that one cannot call kset_register() without
> >> the kset->kobj.name being set--kobj_add_internal() returns -EINVAL,
> >> in this case, i.e. kset_register() fails with -EINVAL.
> >>
> >> Thus, the most common usage is something like this:
> >>
> >> 	kobj_set_name(&kset->kobj, format, ...);
> >> 	kset->kobj.kset = parent_kset;
> >> 	kset->kobj.ktype = ktype;
> >> 	res = kset_register(kset);
> >>
> >> So, what is being leaked, is the memory allocated in kobj_set_name(),
> >> by the common idiom shown above. This needs to be mentioned in
> >> the documentation, at least, in case, in the future this is absolved
> >> in kset_register() redesign, etc.
> > 
> > Based on this, can kset_register() just clean up from itself when an
> > error happens?  Ideally that would be the case, as the odds of a kset
> > being embedded in a larger structure is probably slim, but we would have
> > to search the tree to make sure.
> 
> Looking at kset_register(), we can add kset_put() in the error path,
> when kobject_add_internal(&kset->kobj) fails.
> 
> See the attached patch. It needs to be tested with the same error injection
> as Yang has been doing.
> 
> Now, struct kset is being embedded in larger structs--see amdgpu_discovery.c
> starting at line 575. If you're on an AMD system, it gets you the tree
> structure you'll see when you run "tree /sys/class/drm/card0/device/ip_discovery/".
> That shouldn't be a problem though.

Yes, that shouldn't be an issue as the kobject embedded in a kset is
ONLY for that kset itself, the kset structure should not be controling
the lifespan of the object it is embedded in, right?

Note, the use of ksets by a device driver like you are doing here in the
amd driver is BROKEN and will cause problems by userspace tools.  Don't
do that please, just use a single subdirectory for an attribute.  Doing
deeper stuff like this is sure to cause problems and be a headache.

thanks,

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
