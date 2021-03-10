Return-Path: <SRS0=Hr1N=IJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE9CC433E9
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:38:07 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 74EFD64FEF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:38:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74EFD64FEF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BITw7K104865;
	Thu, 11 Mar 2021 18:38:06 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 373y8byrtr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Mar 2021 18:38:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BIVXrO040425;
	Thu, 11 Mar 2021 18:38:05 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 374kp1d2mn-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 11 Mar 2021 18:38:05 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lKQCB-0004rJ-PI; Thu, 11 Mar 2021 10:38:03 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ngompa13@gmail.com>) id 1lJxzk-0005Ju-R7
	for ocfs2-devel@oss.oracle.com; Wed, 10 Mar 2021 04:31:20 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12ACFXd0180738
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 12:31:20 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 374kn0vtt7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 12:31:20 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12ACEETu021124
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 12:31:19 GMT
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com
	[209.85.219.178]) by userp2040.oracle.com with ESMTP id 3740bwm604-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 12:31:19 +0000
Received: by mail-yb1-f178.google.com with SMTP id d9so17695490ybq.1
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 04:31:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=atKgvCAVpItHVZX4pm9LPMJMeABJeY6Z3gkRYABn5yM=;
	b=Wb84+hXby6eYpbm0hYM6V9wz2B8BdFnZyyMeHHyoqboUJwrUzSH3BBuFhqriimpPwA
	EiBUfnVtIv8AUdP32JLx4hN92SuCLmcUZG8QOJKfgJP/j38HLnxr8pXlr1yig/a3qTAI
	7AX9pZIm6wZDP/Q0gMa0T7bo3bajAuZ2uJJrLD1/1k+FfFV0RMSDZlr36fCNq0PRSncN
	LOEJOc2yQbw6Mkbe9uGa0qghPYp0MUqz5Ox1E4sHFGS5X1G6h02uu2KSrqDa++xn31lA
	C0MkOB0hIs3Vz7yXNzMTgOe7vZDrlhYjnTrc6ZDTrUeCziDAq9zWNwMCWWpUHGa0JQzn
	1ftg==
X-Gm-Message-State: AOAM530T3ayWxlXWVRtaJDKdTiC9Za5rANnPIabLlzyegS0AHqwgitD8
	F82puRsY9itOaSPeUj8nNaT56l32oWNh/esoYBM=
X-Google-Smtp-Source: ABdhPJx2QY4l9cQe75nptZ7Pf1Zho+J5rcKWrpKzrd9BmVRKh3Mvj6bvtkk6JVBRVJMnA8nldnylsisoMg5a0XbleWs=
X-Received: by 2002:a05:6902:1001:: with SMTP id
	w1mr3859288ybt.176.1615379477739; 
	Wed, 10 Mar 2021 04:31:17 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
From: Neal Gompa <ngompa13@gmail.com>
Date: Wed, 10 Mar 2021 07:30:41 -0500
Message-ID: <CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
X-PDR: PASS
X-Source-IP: 209.85.219.178
X-ServerName: mail-yb1-f178.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	phishscore=0 mlxscore=0
	priorityscore=361 impostorscore=0 clxscore=165 bulkscore=0
	lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=891
	adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103100060
X-Spam: Clean
X-Mailman-Approved-At: Thu, 11 Mar 2021 10:38:02 -0800
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        dan.j.williams@intel.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 00/10] fsdax,
	xfs: Add reflink&dedupe support for fsdax
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1034 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110095

T24gVGh1LCBGZWIgMjUsIDIwMjEgYXQgNzoyMyBQTSBTaGl5YW5nIFJ1YW4gPHJ1YW5zeS5mbnN0
QGZ1aml0c3UuY29tPiB3cm90ZToKPgo+IFRoaXMgcGF0Y2hzZXQgaXMgYXR0ZW1wdCB0byBhZGQg
Q29XIHN1cHBvcnQgZm9yIGZzZGF4LCBhbmQgdGFrZSBYRlMsCj4gd2hpY2ggaGFzIGJvdGggcmVm
bGluayBhbmQgZnNkYXggZmVhdHVyZSwgYXMgYW4gZXhhbXBsZS4KPgo+IENoYW5nZXMgZnJvbSBW
MToKPiAgLSBGYWN0b3Igc29tZSBoZWxwZXIgZnVuY3Rpb25zIHRvIHNpbXBsaWZ5IGRheCBmYXVs
dCBjb2RlCj4gIC0gSW50cm9kdWNlIGlvbWFwX2FwcGx5MigpIGZvciBkYXhfZGVkdXBlX2ZpbGVf
cmFuZ2VfY29tcGFyZSgpCj4gIC0gRml4IG1pc3Rha2VzIGFuZCBvdGhlciBwcm9ibGVtcwo+ICAt
IFJlYmFzZWQgb24gdjUuMTEKPgo+IE9uZSBvZiB0aGUga2V5IG1lY2hhbmlzbSBuZWVkIHRvIGJl
IGltcGxlbWVudGVkIGluIGZzZGF4IGlzIENvVy4gIENvcHkKPiB0aGUgZGF0YSBmcm9tIHNyY21h
cCBiZWZvcmUgd2UgYWN0dWFsbHkgd3JpdGUgZGF0YSB0byB0aGUgZGVzdGFuY2UKPiBpb21hcC4g
IEFuZCB3ZSBqdXN0IGNvcHkgcmFuZ2UgaW4gd2hpY2ggZGF0YSB3b24ndCBiZSBjaGFuZ2VkLgo+
Cj4gQW5vdGhlciBtZWNoYW5pc20gaXMgcmFuZ2UgY29tcGFyaXNvbi4gIEluIHBhZ2UgY2FjaGUg
Y2FzZSwgcmVhZHBhZ2UoKQo+IGlzIHVzZWQgdG8gbG9hZCBkYXRhIG9uIGRpc2sgdG8gcGFnZSBj
YWNoZSBpbiBvcmRlciB0byBiZSBhYmxlIHRvCj4gY29tcGFyZSBkYXRhLiAgSW4gZnNkYXggY2Fz
ZSwgcmVhZHBhZ2UoKSBkb2VzIG5vdCB3b3JrLiAgU28sIHdlIG5lZWQKPiBhbm90aGVyIGNvbXBh
cmUgZGF0YSB3aXRoIGRpcmVjdCBhY2Nlc3Mgc3VwcG9ydC4KPgo+IFdpdGggdGhlIHR3byBtZWNo
YW5pc20gaW1wbGVtZW50ZWQgaW4gZnNkYXgsIHdlIGFyZSBhYmxlIHRvIG1ha2UgcmVmbGluawo+
IGFuZCBmc2RheCB3b3JrIHRvZ2V0aGVyIGluIFhGUy4KPgo+Cj4gU29tZSBvZiB0aGUgcGF0Y2hl
cyBhcmUgcGlja2VkIHVwIGZyb20gR29sZHd5bidzIHBhdGNoc2V0LiAgSSBtYWRlIHNvbWUKPiBj
aGFuZ2VzIHRvIGFkYXB0IHRvIHRoaXMgcGF0Y2hzZXQuCj4KPiAoUmViYXNlZCBvbiB2NS4xMSkK
CkZvcmdpdmUgbXkgaWdub3JhbmNlLCBidXQgaXMgdGhlcmUgYSByZWFzb24gd2h5IHRoaXMgaXNu
J3Qgd2lyZWQgdXAgdG8KQnRyZnMgYXQgdGhlIHNhbWUgdGltZT8gSXQgc2VlbXMgd2VpcmQgdG8g
bWUgdGhhdCBhZGRpbmcgYSBmZWF0dXJlCmxpa2UgREFYIHRvIHdvcmsgd2l0aCBDb1cgZmlsZXN5
c3RlbXMgaXMgbm90IGJlaW5nIHdpcmVkIGludG8gKnRoZSoKQ29XIGZpbGVzeXN0ZW0gaW4gdGhl
IExpbnV4IGtlcm5lbCB0aGF0IGZ1bGx5IHRha2VzIGFkdmFudGFnZSBvZgpjb3B5LW9uLXdyaXRl
LiBJJ20gYXdhcmUgdGhhdCBYRlMgc3VwcG9ydHMgcmVmbGlua3MgYW5kIGRvZXMgc29tZQpkYXRh
Y293IHN0dWZmLCBidXQgSSBkb24ndCBrbm93IGlmIEkgd291bGQgY29uc2lkZXIgWEZTIGludGVn
cmF0aW9uCnN1ZmZpY2llbnQgZm9yIGludGVncmF0aW5nIHRoaXMgZmVhdHVyZSBub3csIGVzcGVj
aWFsbHkgaWYgaXQncwpwb3NzaWJsZSB0aGF0IHRoZSBkZXNpZ24gbWlnaHQgbm90IHdvcmsgd2l0
aCBCdHJmcyAoSSBoYWRuJ3Qgc2VlbiBhbnkKZmVlZGJhY2sgZnJvbSBCdHJmcyBkZXZlbG9wZXJz
LCB0aG91Z2ggZ2l2ZW4gaG93IG11Y2ggZW1haWwgdGhlcmUgaXMKaGVyZSwgaXQncyBlbnRpcmVs
eSBwb3NzaWJsZSB0aGF0IEkgbWlzc2VkIGl0KS4KCgotLSAK55yf5a6f44Gv44GE44Gk44KC5LiA
44Gk77yBLyBBbHdheXMsIHRoZXJlJ3Mgb25seSBvbmUgdHJ1dGghCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QK
T2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFu
L2xpc3RpbmZvL29jZnMyLWRldmVs
